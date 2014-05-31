module Gremlin
  class Server < Sinatra::Application

    get '/' do
     p Gremlin.world
    end


    get '/test' do
       Gremlin.world.trigger ::CreateInfrastructure
    end
    get '/test1' do
      Gremlin.world.trigger(EC2::CreateInfrastructure ,1 , 'ami-2918e35e', 'eu-west-1', 'm1.small', 'gremlin@xebia.com')
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