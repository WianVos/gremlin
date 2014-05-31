module Gremlin
  module Mixins
    module Dynflow_mixins

      def world

        return @world if @world

        @world = Dynflow::SimpleWorld.new(
            auto_terminate:      false,
            persistence_adapter: persistence_adapter,
            executor:            -> remote_world do
              Dynflow::Executors::RemoteViaSocket.new(remote_world, socket)
            end)


      end



      def persistance
        return world.persistance
      end

      def socket
        File.join('/tmp', 'dynflow_socket')
      end

      def persistence_adapter
        Dynflow::PersistenceAdapters::Sequel.new('sqlite://db.sqlite')
      end

      def listener
        Dynflow::Listeners::Socket.new(world, socket)
      end

      def lock_file
        File.join('/tmp', 'dynflow_executor.lock')
      end

    end
  end
end