module Gremlin
  class Registry

    class << self
    attr_accessor :templates

    @tasks = Hash.new.with_indifferent_access
    @master_tasks = Hash.new.with_indifferent_access

    def task(key, value)
      @tasks[key] = value
    end

    def tasks
      return @tasks
    end

    def template(template_name)
      p template_name
      @templates = Hash.new unless @templates
      @templates[template_name] = Hash.new unless @templates[template_name]
    end

    def template_parameter(template_name, name, type)
      template(template_name)
      @templates[template_name][name] = type
    end

   end
  end
end