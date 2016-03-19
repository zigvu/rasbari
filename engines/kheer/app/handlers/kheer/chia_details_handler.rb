module Kheer
  class ChiaDetailsHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.dataSuccess
      returnMessage = @message
      returnMessage.trace = "Chia details sent"

      iteration = Iteration.find(@message.iterationId)
      iteration.update({build_model_filename: File.basename(@message.modelBuildPath)})
      returnMessage.storageHostname = iteration.storageMachine.hostname
      returnMessage.storageModelPath = iteration.modelPath

      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::Samosa::ChiaDetails.new(nil).isSameType?(@message)
    end
  end
end
