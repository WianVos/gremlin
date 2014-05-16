module Gremlin
  module Mixins
    module Register_mixins

      def plugin_path
        File.join(File.dirname(__FILE__),"../../../","plugins")
      end

      def asset(&block)

        unless block.nil?
          Gremlin::Registry.instance_eval(&block)
        end

        return @resources
      end


      def load_plugins

        manifest_glob = File.join(File.join(Gremlin.plugin_path),'**', 'gremlin.manifest')
        lib_glob = File.join(File.join(Gremlin.plugin_path),'**', '*.rb')


        manifest_files = Dir.glob(manifest_glob)
        library_files  = Dir.glob(lib_glob)

        manifest_files.each {|file| module_eval File.read(file) }
        library_files.each {|file| p file ; require file}
      end


    end
  end
end