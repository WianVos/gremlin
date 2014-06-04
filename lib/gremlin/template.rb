module Gremlin
  class Template < Dynflow::Action

    # the class needs an instances attribute to keep track of all the instances
    class << self
      attr_accessor :templates



      # A template is a atomic action accessible by the outside world
      # it strings together multiple dynflow tasks in order to complete a real world task

      def inherited(child)

        Gremlin::Registry.template(child.to_s)
        super
      end



      #class methods

      # register required parameters with the gremlin registry
      def required_parameter(name, type = string)
        Gremlin::Registry.template_parameter(self.name, name, type)
      end

    end

    # instance methods
    attr_accessor :config


    # get the available config for this class if any
    def config
      Gremlin.config["#{self.class}"].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} if Gremlin.config["#{self.class}"]
    end

    def merged_args(args)
      args.first.merge!(config) if args.first && config
    end
  end
end