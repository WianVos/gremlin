module Gremlin
  class Action < Dynflow::Action

    def inherited
      p self
      super
    end

  end
end