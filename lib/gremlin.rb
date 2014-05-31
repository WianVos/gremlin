require 'dynflow'
require 'logger'
require 'tmpdir'
require 'yaml'
require 'ostruct'

require 'sinatra'
require 'sinatra/json'

require 'gremlin/version'


module Gremlin

  autoload :Mixins,      'gremlin/mixins'
  autoload :Server,      'gremlin/server'
  autoload :Registry,    'gremlin/registry'
  autoload :Daemon,      'gremlin/daemon'

  extend Mixins::Config_mixins
  extend Mixins::Dynflow_mixins
  extend Mixins::Register_mixins

  load_config
  load_plugins



end
