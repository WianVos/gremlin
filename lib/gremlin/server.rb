
module Gremlin
  class Server < Sinatra::Application

    #include the various sinatra url resources
    # these are located under ./server


    get '/config' do
    end

    get '/test' do

      test = Gremlin.world.plan(::CreateInfrastructure)


      test2 = Gremlin.world.execute(test.id)


      json test2
    end
    get '/test1' do
      Gremlin.world.trigger(EC2::CreateInfrastructure, hostcount: 2, type: 'm1.small')
    end

    get '/logger' do
     Gremlin.logger.error "testing"
     json Gremlin.logger.methods

    end

    get '/tasks' do
      json Gremlin::Registry.tasks
    end

    get '/plans' do
     json Gremlin.world.persistence.find_execution_plans({}).collect {|e| {'id' => e.id,
                                                                           'action' => e.root_plan_step.action_class.name,
                                                                           'state' => e.state,
                                                                           'result' => e.result }}
    end

    get '/templates' do

      json Gremlin::Registry.templates
    end


    get '/job' do

      job = Gremlin::Job.new(:template => 'CreateInfrastructure', :user => 'wian', :schedule => 'in:15s')

      job.execute

      pp job.flow_hash
      sleep 10
      pp job.flow_hash
      json job.flow_hash

    end

    get '/jobs' do
      json Gremlin::Job.all_to_hash
    end

  end
end
