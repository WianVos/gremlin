module Gremlin
  module Mixins
    module Register_mixins

      def default_plugin_path
        File.join(File.dirname(__FILE__),"../../../","plugins")
      end


      def load_plugin_path
        #manifest_glob = File.join(File.join(Gremlin.plugin_path),'**', 'gremlin.manifest')
        lib_glob = File.join(File.join(Gremlin.default_plugin_path),'**', '*.rb')

        #manifest_files = Dir.glob(manifest_glob)
        Dir.glob(lib_glob)
      end

      def load_plugins(path = load_plugin_path)
        #manifest_files.each {|file| module_eval File.read(file) }
        path.each {|file|  require file}
      end



    end
  end
end