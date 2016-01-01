module Video
  class ClipCaptureHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.dataSuccess
      # TODO: change. for now, send dummy paths
      @message.clipId = 0
      @message.storageUrl = "/tmp/capture/rasbari_#{@message.ffmpegName}"
      returnMessage = @message
      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::VideoCapture::ClipDetails.new(nil).isSameType?(@message)
    end
  end
end
