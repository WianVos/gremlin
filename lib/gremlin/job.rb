require_relative('job/flow')
require_relative('job/plan')

class String
  def to_class
    self.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end

module Gremlin


  class Job < Serializable

    include Gremlin::Job::Flow
    include Gremlin::Job::Plan

    include Algebrick::TypeCheck
    include Algebrick::Matching



     class << self
      attr_accessor :instances, :initialized

      def new_from_hash(hash)
        check_class_matching hash
        self.new(hash)
      end

      def states
        [:new, :pending, :planning, :planned, :running, :paused, :stopped]
      end

      def init
        unless initialized
          Gremlin.gremlin_persistence.find_jobs filters: { 'state' => states.map(&:to_s) - ['stopped'] }
          @initialized = true
        end
      end

      def save_all
        instances.each {|i| i.save } if instances
      end

      def update_all
        save_all
        instances.each {|i| i.destroy if i.done? } if instances
      end

      def all
        instances ? instances.dup : []
      end

      def count
        instances ? instances.count : 0
      end

      def all_to_hash
        all.collect {|x|
                               {:name     => x.job_id,
                                :state    => x.state,
                                :progress => x.progress,
                                :planned  => x.planned?,
                                :plan_id  => x.plan_id }
        }
      end
    end

    attr_accessor :template, :user, :args, :schedule
    attr_reader :plan_id,  :job_id, :validated

    def initialize(*attributes)


      @template   = Type! attributes.first.fetch(:template), String
      @user       = Type! attributes.first.fetch(:user, 'anonymouse'), String

      # try to translate the args back from a marshall dump if applicable
      @args       = try_marshal_load attributes.first.fetch(:args,{})

      @job_id     = Type! attributes.first.fetch(:job_id,"#{user}:#{template}:#{timestamp}"), String
      @state      = attributes.first.fetch(:state, :new)
      @plan_id    = Type! attributes.first.fetch(:plan_id, 'none'), String

      # check if this job has a schedule passed to it
      # schedules are defined like sort_by
      # at:<date>
      # in:<time unit>
      # example
      # at:2030/12/12 23:30:00
      # in:3s
      #
      # if no schedule is passed a delay of 1 second will be used

      @schedule   = Type! attributes.first.fetch(:schedule, 'in:1s'), String


      #
      @validated  = false


      # we always plan the job
      plan unless planned?

      self.class.instances ||= Array.new
      self.class.instances << self
      self.save
    end

    def validated

      return @validated if @validated

      begin
        Gremlin::Registry.templates[template]["required_parameters"].each { |k,v|
          raise "#{template}: argument #{k} not found in passed arguments" unless args[k]
          raise "#{template}: argument #{k} should be of type: #{v}, but it is a #{args[k].is_a?}" unless Type?(args[k], v)
        } if Gremlin::Registry.templates[template]["required_parameters"]
        @validated = true
      rescue
        @validated = false
      end

      return @validated
    end

    # try to do a marshal load of a suspected hash unless it's a hash

    def try_marshal_load(input)
      begin
        return Marshal.load(input)
      rescue
        return input
      end
    end

    def destroy
      self.class.instances.delete(self)
    end

    def done?
      state == :stopped
    end

    # orders dynflow to plan the job
    # we can only plan an order once ..
    # so if it's already planned .. do not plan it again
    def plan
     unless planned?
      @plan_id = Gremlin.world.plan(template.to_class, args).id if validated
      self.save
     end
    end

    # is this job planned?
    def planned?
      return false unless @plan_id != 'none'
      return true
    end

    # lets execute the job
    # all jobs get scheduled
    def execute


      raise "this job is not in the planned phase yet" unless planned?

      if schedule_form == 'at'
        Gremlin.scheduler.at schedule_time do Gremlin.world.execute(plan_id) end
      else
        Gremlin.scheduler.in schedule_time do Gremlin.world.execute(plan_id) end
      end

      self.save
    end

    def timestamp
      DateTime.now.to_s
    end

    def execution_plan
      return nil unless planned?
      Gremlin.world.persistence.load_execution_plan(plan_id)
    end

    def state

      @state = execution_plan.state if planned?

      return @state

    end

    def progress

      return execution_plan.progress if planned?
      return 'unplanned'
    end


    def schedule_form
      @schedule.split(':')[0] if @schedule
    end

    def schedule_time
      @schedule.split(':')[1] if @schedule
    end

    def to_hash
      recursive_to_hash job_id:            self.job_id,
                        class:             self.class.to_s,
                        template:          self.template,
                        user:              self.user,
                        args:              Marshal.dump(self.args),
                        schedule:          self.schedule,
                        plan_id:           self.plan_id || nil,
                        state:             self.state

    end

    def save
      Gremlin.gremlin_persistence.save_job(self)
    end



    end
end