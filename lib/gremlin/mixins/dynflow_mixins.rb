module Gremlin
  module Mixins
    module Dynflow_mixins

      def world

        return @world if @world

        socket_path         = File.join(Dir.tmpdir, 'dynflow_socket')
        persistence_adapter = Dynflow::PersistenceAdapters::Sequel.new('sqlite://db.sqlite')
        @world = Dynflow::SimpleWorld.new do |world|
          { persistence_adapter: persistence_adapter}
        end

      end

      def persistance
        return world.persistance
      end

    end
  end
end