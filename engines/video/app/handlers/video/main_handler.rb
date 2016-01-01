module Video
  class MainHandler
    def initialize
    end

    def call(header, message)
      Rails.logger.debug("Video::MainHandler: Request header : #{header}")
      Rails.logger.debug("Video::MainHandler: Request message: #{message}")

      returnHeader = Messaging::Messages::Header.statusFailure
      returnMessage = Messaging::Messages::MessageFactory.getNoneMessage

      begin
        pingHandler = Video::PingHandler.new(header, message)
        returnHeader, returnMessage = pingHandler.handle if pingHandler.canHandle?

        clipCaptureHandler = Video::ClipCaptureHandler.new(header, message)
        returnHeader, returnMessage = clipCaptureHandler.handle if clipCaptureHandler.canHandle?

      rescue => e
        Rails.logger.error("Video::MainHandler: #{e}")
      end

      Rails.logger.debug("Video::MainHandler: Served header : #{returnHeader}")
      Rails.logger.debug("Video::MainHandler: Served message: #{returnMessage}")

      return returnHeader, returnMessage
    end
  end
end
