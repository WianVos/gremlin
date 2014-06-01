module EC2
  class CreateInfrastructure < Dynflow::Action
    extend EC2::Config


    def plan (host_count, ami, region, type, key_pair_name)
      # start concurrent actions to create the needed machines
      sequence do
        createkeypair = plan_action(EC2::CreateKeyPair, :region => region)
        concurrence do
          host_count.times do
            createinstance = plan_action(EC2::CreateInstance,
                                               :ami => ami,
                                               :region => region,
                                               :type => type,
                                               :key_pair_name => createkeypair.output[:key_pair_name] )
            plan_action(EC2::CheckResult, :id => createinstance.output[:id], :region => region)
          end
        end
      end


    end

  end
end