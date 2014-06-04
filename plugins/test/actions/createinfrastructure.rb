class CreateInfrastructure < Gremlin::Template

  def plan (*args)

    #merge the arguments we've gotten with the config
    # we'll add to this has as we go and pass the args hash to the various plan_action methods
    args = merged_args(args)
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
