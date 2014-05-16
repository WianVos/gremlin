module Gremlin
  class Registry

    @tasks = Hash.new.with_indifferent_access
    @master_tasks = Hash.new.with_indifferent_access

    def self.task(key, value)
      @tasks[key] = value
    end

    def self.master_task(key, value)
      @tasks[key] = value
    end

    def self.tasks
      return @tasks
    end

  end
end