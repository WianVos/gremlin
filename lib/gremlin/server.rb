
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


  end
end
#
# <td><%= h(plan.id) %></td>
#     <td><%= h(plan.root_plan_step.action_class.name) %></td>
#     <th><%= h(plan.state) %></th>
# <th><%= h(plan.result) %></th>
#     <th><%= h(plan.started_at) %></th>
#     <td><a href="<%= h(url("/#{plan.id}")) %>">Show</a></td>
