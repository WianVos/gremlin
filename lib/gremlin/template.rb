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

      def all
        # return listing of project objects
        self.templates ? self.templates.dup : []
      end

      def count
        # return a count of existing orders
        templates ? templates.count : 0
      end

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
      p args.first.merge!(config) if args.first && config
      args.first.merge!(config) if args.first && config
    end
  end
end