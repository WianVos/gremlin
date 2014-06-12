module Gremlin
  class Job < Serializable
    module Plan
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


    end
  end
end