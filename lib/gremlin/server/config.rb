module EC2
  class Server < Sinatra::Application
    namespace "/config" do

      get '/' do
        json Gremlin.config
      end

    end
  end
end