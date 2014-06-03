module Gremlin
  class Job

    class << self

      attr_accessor :instances

      def all
        instances ? instances.dup : []
      end

      def count
        instances ? instances.count : 0
      end

    end

    attr_accessor :name, :template, :plan_id

    def initialize
      
      self.class.instances ||= Array.new
      self.class.instances << self

    end

    def self.all
      # return listing of project objects
      instances ? instances.dup : []
    end

    def self.count
      # return a count of existing projects
      instances ? instances.count : 0
    end

    def destroy
      self.class.instances.delete(self)
    end

  end
end