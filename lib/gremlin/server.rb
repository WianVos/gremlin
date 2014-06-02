module Gremlin
  class Server < Sinatra::Application

    #include the various sinatra url resources
    # these are located under ./server
    Dir.glob(File.join(File.dirname(__FILE__),'server/*.rb')).each {|r| load r }

    get '/config' do
    end

    get '/test' do
       Gremlin.world.trigger ::CreateInfrastructure
    end
    get '/test1' do
      Gremlin.world.trigger(EC2::CreateInfrastructure ,4 , 'ami-2918e35e', 'eu-west-1', 'm1.small', 'gremlin@xebia.com')
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
  end
end
#
# <td><%= h(plan.id) %></td>
#     <td><%= h(plan.root_plan_step.action_class.name) %></td>
#     <th><%= h(plan.state) %></th>
# <th><%= h(plan.result) %></th>
#     <th><%= h(plan.started_at) %></th>
#     <td><a href="<%= h(url("/#{plan.id}")) %>">Show</a></td>
