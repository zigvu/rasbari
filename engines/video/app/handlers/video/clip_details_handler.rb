module Video
  class ClipDetailsHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.dataSuccess
      returnMessage = @message
      returnMessage.trace = "Clip created"

      capture = Video::Capture.find(@message.captureId)
      clip = capture.clips.create
      clip.state.setCreated

      returnMessage.clipId = clip.id
      returnMessage.storageClipPath = clip.clipPath
      returnMessage.storageThumbnailPath = clip.thumbnailPath

      return returnHeader, returnMessage
    end

    def canHandle?
      Messaging::Messages::VideoCapture::ClipDetails.new(nil).isSameType?(@message)
    end
  end
end
