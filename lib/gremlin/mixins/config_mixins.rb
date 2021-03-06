require 'ostruct'
require 'yaml'

module Gremlin
  module Mixins
    module Config_mixins

      def app_root
        File.join(File.dirname(__FILE__),"../../../")
      end

#      def global_conf_files
#        global_conf_glob = File.join(File.join(app_root),'etc/*.yaml')
#        Dir.glob(global_conf_glob)
#      end

      def plugin_conf_files
        plugin_conf_glob = File.join(File.join(app_root),'plugins/**/*.yaml')
        Dir.glob(plugin_conf_glob)
      end

      def config
        return @config if @config

          globalconfig = {}
          pluginconfig = {}
          #plugins = {}

          global = YAML.load(File.read("#{app_root}/etc/gremlin.yaml"))
          global.each do |key,val|

            globalconfig[key] = val
          end

          # Create global entry
          #config['global'] = YAML.load(File.read("#{app_root}/etc/gremlin.yaml"))

          plugin_conf_files.each do |pluginfile|
            #pluginname = Pathname.new(File.expand_path("../.",pluginfile)).basename.to_s
            pluginhash = YAML.load(File.read(pluginfile))
            pluginhash.each do |key,val|

              pluginconfig[key] = val
            end
          end

          @config = pluginconfig.merge(globalconfig)

          return @config
      end

      def gremlin_persistence
        return @gremlin_persistence if @gremlin_persistence

        @gremlin_persistence = Gremlin::Persistence.new(Gremlin::PersistenceAdapters::Sequel.new('sqlite://db.sqlite'))

      end

      def gremlin_job_init
        Gremlin::Job.init
      end


    end
  end
end
