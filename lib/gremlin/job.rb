class String
  def to_class
    self.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end

module Gremlin
  class Job

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


      @validated  = false
      @job_id     = "#{user}:#{template}:#{timestamp}"

      self.class.instances ||= Array.new
      self.class.instances << self
    end

    def validated
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

    def plan
     @plan_id = Gremlin.world.plan(template.to_class, args).id if validated
    end

    def planned?
      return false unless @plan_id
      return true
    end

    def execute
      if planned?
        Gremlin.world.execute(plan_id)
      else
        raise "this job is not in the planned phase yet"
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

    # plan stuff

    def plan_hash
      return step_to_hash(root_plan_step)
    end

    def step_to_hash(step)
      step_hash = Hash.new
      step_hash[:name] = step_action_class(step)
      step_hash[:input] = action_input(step_action(step)) unless action_input(step_action(step)).empty?
      step_hash[:error] = step_error(step) unless step_error(step).nil?
      step_hash[:substeps] = step_substeps(step).collect {|ss| step_to_hash(ss)} unless step_substeps(step).collect {|ss| step_to_hash(ss)}.empty?
      return step_hash
    end

    def step_action_class(step)
      step.action_class
    end

    def step_children(step)
      step.children
    end

    def step_action(step)
      return step.action execution_plan if planned?
      return nil
    end

    def step_error(step)
      return step.error if step.error
      return nil
    end

    def step_substeps(step)
      step.children.collect {|ss_id| execution_plan.steps[ss_id] }
    end

    def action_input(action)
      return action.input if action.input
      return nil
    end

    def root_plan_step
      return execution_plan.root_plan_step if planned?
      return nil
    end

    # flow stuff
    def flow_hash(flow = run_flow)

      flow_hash = Hash.new
      if is_atom?(flow)
        flow_hash[:id] = flow_id(flow)
        flow_hash[:action] = flow_action_class(flow)
        flow_hash[:status] = flow_status_hash(flow)
      end
      if is_sequence?(flow)
        flow_hash[:sequence] = sub_flow_hash(flow)
      end

      if is_concurrence?(flow)
        flow_hash[:concurrence] = sub_flow_hash(flow)
      end
      return flow_hash
    end

    def sub_flow_hash(flow)
      flow_sub_flows(flow).collect {|f| flow_hash(flow = f)}
    end

    def run_flow
      return execution_plan.run_flow if planned?
      return nil
    end

    def is_atom?(flow)
      return true if flow.is_a? Dynflow::Flows::Atom
      return false
    end

    def is_sequence?(flow)
      return true if flow.is_a? Dynflow::Flows::Sequence
      return false
    end

    def is_concurrence?(flow)
      return true if flow.is_a? Dynflow::Flows::Concurrence
      return false
    end

    def flow_step(flow)
      return execution_plan.steps[flow.step_id] if is_atom?(flow)
      return nil
    end

    def flow_id(flow)
      return flow_step(flow).id if is_atom?(flow)
      return nil
    end

    def flow_sub_flows(flow)
      return flow.sub_flows unless is_atom?(flow)
      return nil
    end

    def flow_action_class(flow)
      if is_atom?(flow)
       return flow_step(flow).action_class.name
      end
      return nil
    end

    def flow_state(flow)
      if is_atom?(flow)
        return flow_step(flow).state
      end
      return nil
    end

    def flow_duration(flow)
      if is_atom?(flow) && flow_state(flow) != :pending
        return flow_step(flow).state
      end
      return nil
    end

    def flow_status_hash(flow)

      flow_status_hash = Hash.new
      step = flow_step(flow)

      flow_status_hash['state'] = flow_state(flow)

      unless flow_state(flow) == :pending
        flow_status_hash['started_at'] = step.started_at
        flow_status_hash['ended_at'] = step.ended_at
        flow_status_hash['real_time'] = duration_to_s(step.real_time)
        flow_status_hash['execution_time'] = duration_to_s(step.execution_time)
      end

      flow_status_hash['input'] = step_action(step).input
      flow_status_hash['output'] = step_action(step).output

      if step.error
        flow_status_hash['error'] = step.error.exception_class
        flow_status_hash['error_message'] = step.error.message
        flow_status_hash['error_backtrace'] = step.error.backtrace
      end
      return flow_status_hash
    end

    def duration_to_s(duration)
      "%0.2fs" % duration
    end
  end
end