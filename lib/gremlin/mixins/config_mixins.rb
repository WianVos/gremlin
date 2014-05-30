module Gremlin
  module Mixins
    module Config_mixins

      def app_root
        File.expand_path( '../../../', File.dirname(__FILE__))
      end

      def conf_dir
        File.join(app_root, etc)
      end

      def load_config
        if Sinatra::Application.environment == :production
        else
        end
      end

    end
  end
end