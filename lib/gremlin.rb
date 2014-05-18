require 'dynflow'
require 'logger'
require 'tmpdir'

require 'sinatra'
require 'sinatra/json'

require 'gremlin/version'


module Gremlin

  autoload :Mixins,      'gremlin/mixins'
  autoload :Server,      'gremlin/server'
  autoload :Registry,    'gremlin/registry'

  extend Mixins::Dynflow_mixins
  extend Mixins::Register_mixins

  load_plugins



end
