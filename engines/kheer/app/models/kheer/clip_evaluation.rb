module Kheer
  class ClipEvaluation
    include Mongoid::Document

    # meta data for indexing
    # -------------------------------------------
    field :cl, as: :clip_id, type: Integer
    field :st, as: :zstate, type: String

    def clip
      return Video::Clip.find(self.clip_id)
    end

    def state
      Kheer::ClipEvaluationStates.new(self)
    end

    # TODO: move to storage path generator
    def path
      "#{self.capture_evaluation.path}/#{self.clip_id}"
    end
    def localizationDataPath
      "/data/#{self.capture_evaluation.storageMachine.hostname}/#{self.path}/localization.json"
    end

    embedded_in :capture_evaluation, class_name: "Kheer::CaptureEvaluation"
  end
end
