module Gremlin
  class Server < Sinatra::Application

    #include the various sinatra url resources
    # these are located under ./server
    Dir.glob(File.join(File.dirname(__FILE__),'server/*.rb')).each {|r|
      p r
      load r }

  end
end
#
# <td><%= h(plan.id) %></td>
#     <td><%= h(plan.root_plan_step.action_class.name) %></td>
#     <th><%= h(plan.state) %></th>
# <th><%= h(plan.result) %></th>
#     <th><%= h(plan.started_at) %></th>
#     <td><a href="<%= h(url("/#{plan.id}")) %>">Show</a></td>