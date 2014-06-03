
module EC2
  class CreateInfrastructure < Gremlin::Template

    required_parameter 'hostcount', type = Integer
    required_parameter 'type', type = String


    def plan (*args)

      #merge the arguments we've gotten with the config
      # we'll add to this has as we go and pass the args hash to the various plan_action methods
      args = merged_args(args)


      # enable mocking if mock is set in the config



      # start a sequence of actions to create the needed machines
      sequence do
        #let's start with a key_pair so we can login to the machines later on
        createkeypair = plan_action(EC2::CreateKeyPair, args)


        # the next couple of actions can take place concurrently
        concurrence do
          # each host can be created concurrently
          args[:hostcount].times do

            # the CreateInstance action needs the key_pair_name from the createkeypair action
            args[:key_pair_name] = createkeypair.output[:key_pair_name]

            createinstance = plan_action(EC2::CreateInstance, args)

            # Add the instance id to the args hash (needed bij checkResult)
            args[:id] = createinstance.output[:id]


            plan_action(EC2::CheckResult, args)

          end
        end
      end


    end

  end
end