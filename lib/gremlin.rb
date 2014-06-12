require 'dynflow'
require 'logger'
require 'tmpdir'
require 'yaml'
require 'ostruct'
require 'rufus-scheduler'

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'

require 'gremlin/version'


module Gremlin

  autoload :Mixins,               'gremlin/mixins'
  autoload :Server,               'gremlin/server'
  autoload :Registry,             'gremlin/registry'
  autoload :Action,               'gremlin/action'
  autoload :Template,             'gremlin/template'
  autoload :Job,                  'gremlin/job'
  autoload :Persistence,          'gremlin/persistence'
  autoload :PersistenceAdapters,  'gremlin/persistence_adapters'
  autoload :Serializable,         'gremlin/serializable'

  extend Mixins::Config_mixins
  extend Mixins::Dynflow_mixins
  extend Mixins::Register_mixins
  extend Mixins::Scheduler_mixins


  config
  load_plugins

  gremlin_job_init

end
