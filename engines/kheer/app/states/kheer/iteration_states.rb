module Kheer
  class IterationStates < BaseAr::ArAccessor

    def self.states
      ["configuring", "configured", "building", "finalized"]
    end
    zextend BaseState, Kheer::IterationStates.states

    def initialize(iteration)
      super(iteration, :zstate)
    end

  end
end
