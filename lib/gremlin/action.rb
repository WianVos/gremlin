module Gremlin
  class Action < Dynflow::Action

    def self.inherited(child)
      super(child)
    end

  end
end