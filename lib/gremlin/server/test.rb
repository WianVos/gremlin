module EC2
  class Server < Sinatra::Application

    namespace '/test' do

      get '/' do
        p Gremlin.world
      end

      get '/test' do
        p 'testing'
       test = Gremlin.world.trigger(::CreateInfrastructure)
       p test

       p " testing "
       json test
      end
      get '/test1' do
        Gremlin.world.trigger(EC2::CreateInfrastructure ,2 , 'ami-2918e35e', 'eu-west-1', 'm1.small', 'gremlin@xebia.com')
      end
      get '/test2' do
        p Gremlin.world.plan(EC2::CreateInfrastructure ,2 , 'ami-2918e35e', 'eu-west-1', 'm1.small', 'gremlin@xebia.com')
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

      get '/order' do
        order = Gremlin.Order.new('test', 'test')
        p order
        p Gremlin.Order.all
      end
    end
  end
end