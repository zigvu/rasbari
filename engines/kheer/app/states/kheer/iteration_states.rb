module Kheer
  class IterationStates < BaseAr::ArAccessor

    def self.states
      ["configuring", "configured", "building", "built", "failed"]
    end
    zextend BaseState, Kheer::IterationStates.states

    def initialize(iteration)
      super(iteration, :zstate)
    end

  end
end
