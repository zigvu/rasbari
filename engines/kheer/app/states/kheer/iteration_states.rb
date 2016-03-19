module Kheer
  class IterationStates < BaseAr::ArAccessor

    def self.states
      ["configuring", "configured", "building", "built"]
    end
    zextend BaseState, Kheer::IterationStates.states

    def initialize(iteration)
      super(iteration, :zstate)
    end

  end
end
