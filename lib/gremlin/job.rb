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


  class Job

    include Gremlin::Job::Flow
    include Gremlin::Job::Plan

    include Algebrick::TypeCheck
    include Algebrick::Matching

    class << self

      attr_accessor :instances

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

    attr_accessor :template, :user, :args
    attr_reader :plan_id,  :job_id, :validated

    def initialize(*attributes)

      @template   = Type! attributes.first.fetch(:template), String
      @user       = Type! attributes.first.fetch(:user, 'anonymouse'), String
      @args       = Type! attributes.first.fetch(:args,{}), Hash

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
      @job_id     = "#{user}:#{template}:#{timestamp}"

      # we always plan the job
      plan

      self.class.instances ||= Array.new
      self.class.instances << self
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

    def destroy
      self.class.instances.delete(self)
    end

    # orders dynflow to plan the job
    def plan
     @plan_id = Gremlin.world.plan(template.to_class, args).id if validated
    end

    # is this job planned?
    def planned?
      return false unless @plan_id
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


    end

    def timestamp
      DateTime.now.to_s
    end

    def execution_plan
      return nil unless planned?
      Gremlin.persistance.load_execution_plan(plan_id)
    end

    def state
      return execution_plan.state if planned?
      return 'unplanned'
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

    end
end