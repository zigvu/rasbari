module Video
  class ClipCaptureHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.dataSuccess
      capture = Video::Capture.find(@message.captureId)
      clip = capture.clips.create
      clip.state.setCreated

      @message.clipId = clip.id
      @message.storageClipPath = clip.clipPath
      @message.storageThumbnailPath = clip.thumbnailPath
      returnMessage = @message
      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::VideoCapture::ClipDetails.new(nil).isSameType?(@message)
    end
  end
end
