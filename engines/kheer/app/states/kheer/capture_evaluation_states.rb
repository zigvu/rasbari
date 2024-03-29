module Kheer
  class CaptureEvaluationStates < BaseAr::ArAccessor

    def self.states
      ["configuring", "configured", "evaluating", "evaluated"]
    end
    zextend BaseState, Kheer::CaptureEvaluationStates.states

    def initialize(capEvaluation)
      super(capEvaluation, :zstate)
    end

  end
end
