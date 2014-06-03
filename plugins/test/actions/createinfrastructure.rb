class CreateInfrastructure < Dynflow::Action

  def plan
    sequence do
      concurrence do
        plan_action(CreateMachine, 'host1', 'db')
        plan_action(CreateMachine, 'host2', 'storage')
      end
      plan_action(CreateMachine,
                  'host3',
                  'web_server',
                  :db_machine => 'host1',
                  :storage_machine => 'host2')
    end
    sleep 2
  end
end
