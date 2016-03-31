module Kheer
  class KhajuriStateQueryHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.statusSuccess
      returnMessage = @message
      returnMessage.trace = "Khajuri state query updated"

      capEval = CaptureEvaluation.find(@message.capEvalId)
      state = Messaging::States::Samosa::KhajuriStates.new(@message.state)
      if state.isEvaluating?
        capEval.state.setEvaluating
      elsif state.isEvaluated?
        # we set evaluated when all clips have been ingested
        # capEval.state.setEvaluated
        capEval.gpuMachine.state.setReady
      end

      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::Samosa::KhajuriStateQuery.new(nil).isSameType?(@message)
    end
  end
end
