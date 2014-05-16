require 'gremlin'

run Gremlin::Application

require 'dynflow/web_console'

dynflow_console = Dynflow::WebConsole.setup do
  set :world, Gremlin.world
end

map '/dynflow' do
  run dynflow_console
end