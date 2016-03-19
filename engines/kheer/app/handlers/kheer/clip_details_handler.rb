module Kheer
  class ClipDetailsHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.dataSuccess
      returnMessage = @message
      returnMessage.trace = "Clip located"

      clip = Video::Clip.find(@message.clipId)
      returnMessage.storageHostname = clip.capture.storageMachine.hostname
      returnMessage.storageClipPath = clip.clipPath

      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::Samosa::ClipDetails.new(nil).isSameType?(@message)
    end
  end
end
