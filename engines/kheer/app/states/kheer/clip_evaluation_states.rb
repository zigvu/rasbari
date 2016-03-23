module Kheer
  class ClipEvaluationStates < BaseAr::ArAccessor

    # needs to match:
    # messaging/states/states/samosa/cap_eval_states.rb

    def self.states
      ["configuring", "downloaded", "evaluated", "failed"]
    end
    zextend BaseState, Kheer::ClipEvaluationStates.states

    def initialize(clip_evaluation)
      super(clip_evaluation, :zstate)
    end

  end
end
