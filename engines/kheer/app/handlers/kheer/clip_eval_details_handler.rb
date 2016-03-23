module Kheer
  class ClipEvalDetailsHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.dataSuccess
      returnMessage = @message
      returnMessage.trace = "Eval data updated"

      clip = Video::Clip.find(@message.clipId)
      capEval = CaptureEvaluation.find(@message.capEvalId)
      clipEval = capEval.clip_evaluations.where(clip_id: @message.clipId).first
      returnMessage.storageHostname = clip.capture.storageMachine.hostname
      returnMessage.storageResultPath = clipEval.localizationDataPath

      clipEvalState = @message.getClipEvalState
      clipEval.state.setDownloaded if clipEvalState.isDownloaded?
      clipEval.state.setEvaluated if clipEvalState.isEvaluated?
      clipEval.state.setFailed if clipEvalState.isFailed?

      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::Samosa::ClipEvalDetails.new(nil).isSameType?(@message)
    end
  end
end
