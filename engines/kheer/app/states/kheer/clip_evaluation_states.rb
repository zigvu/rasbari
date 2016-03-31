module Kheer
  class ClipEvaluationStates < BaseAr::ArAccessor

    # needs to match:
    # messaging/states/states/samosa/clip_eval_states.rb

    def self.states
      ["configuring", "downloaded", "evaluated", "ingested", "failed"]
    end
    zextend BaseState, Kheer::ClipEvaluationStates.states

    def initialize(clip_evaluation)
      super(clip_evaluation, :zstate)
    end

  end
end
