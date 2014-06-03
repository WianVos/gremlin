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
          #config['plugins'] = plugins
          #configstruct = OpenStruct.new(config)
          #config
          #@config
          @config = pluginconfig.merge(globalconfig)
          puts @config
          return @config
      end

    end
  end
end
