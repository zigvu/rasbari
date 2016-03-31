module Kheer
  class ChiaStateQueryHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.statusSuccess
      returnMessage = @message
      returnMessage.trace = "Chia state query updated"

      iteration = Iteration.find(@message.iterationId)
      state = Messaging::States::Samosa::ChiaStates.new(@message.state)
      if state.isFailed?
        iteration.state.setFailed
        iteration.gpuMachine.state.setReady
      elsif state.isUploaded?
        iteration.state.setBuilt
        iteration.gpuMachine.state.setReady
      else
        iteration.state.setBuilding
      end

      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::Samosa::ChiaStateQuery.new(nil).isSameType?(@message)
    end
  end
end
