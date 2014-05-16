module Gremlin
  class Application < Sinatra::Application

    get '/' do
     p Gremlin.world
    end


    get '/test' do
       Gremlin.world.trigger ::CreateInfrastructure
    end

    get '/tasks' do
      json Gremlin::Registry.tasks
    end
  end
end