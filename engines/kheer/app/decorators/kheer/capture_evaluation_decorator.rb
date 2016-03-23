module Kheer
  class CaptureEvaluationDecorator < Draper::Decorator
    delegate_all

    def toMessage
      ar = {
        capEvalId: object.id.to_s,
        storageHostname: object.storageMachine.hostname,
        storageTestInputPath: object.testInputPath,
        storageModelPath: object.chia_model.iteration.modelPath,
        clipIds: object.capture.clips.pluck(:id)
      }
      Messaging::Messages::Samosa::KhajuriDetails.new(ar)
    end

    def downloadedClipsNum
      object.clip_evaluations.where(zstate: Kheer::ClipEvaluationStates.downloaded).count
    end
    def evaluatedClipsNum
      object.clip_evaluations.where(zstate: Kheer::ClipEvaluationStates.evaluated).count
    end
    def totalClipsNum
      object.clip_evaluations.count
    end
    def queuedClipsNum
      totalClipsNum - (downloadedClipsNum + evaluatedClipsNum)
    end

    def downloadedClipsPer
      (100.0 * downloadedClipsNum/totalClipsNum).round(2)
    end
    def evaluatedClipsPer
      (100.0 * evaluatedClipsNum/totalClipsNum).round(2)
    end
    def queuedClipsPer
      (100.0 * queuedClipsNum/totalClipsNum).round(2)
    end
    def progress
      downloadedClipsPer + evaluatedClipsPer
    end

  end
end
