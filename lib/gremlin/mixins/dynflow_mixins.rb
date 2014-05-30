module Gremlin
  module Mixins
    module Dynflow_mixins

      def world

        return @world if @world

        socket_path         = File.join('/tmp', 'dynflow_socket')
        persistence_adapter = Dynflow::PersistenceAdapters::Sequel.new('sqlite://db.sqlite')
        @world = Dynflow::SimpleWorld.new(
            auto_terminate:      false,
            persistence_adapter: persistence_adapter,
            executor:            -> remote_world do
              Dynflow::Executors::RemoteViaSocket.new(remote_world, socket_path)
            end)


      end



      def persistance
        return world.persistance
      end


    end
  end
end