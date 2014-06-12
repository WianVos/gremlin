module Gremlin
  class Job < Serializable
    module Flow
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
end