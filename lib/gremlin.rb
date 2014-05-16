require 'dynflow'
require 'logger'
require 'tmpdir'

require 'sinatra'
require 'sinatra/json'

require 'gremlin/version'


module Gremlin

  autoload :Application, 'gremlin/application'
  autoload :Mixins,      'gremlin/mixins'
  autoload :Registry,     'gremlin/registry'

  extend Mixins::Dynflow_mixins
  extend Mixins::Register_mixins

  load_plugins



end
