module Video
  class MainHandler
    def initialize
    end

    def call(header, message)
      Rails.logger.debug("Video::CaptureHandler: Request header : #{header}")
      Rails.logger.debug("Video::CaptureHandler: Request message: #{message}")

      returnHeader = Messaging::Messages::Header.statusFailure
      returnMessage = Messaging::Messages::MessageFactory.getNoneMessage

      begin
        pingHandler = Video::PingHandler.new(header, message, @captureState)
        returnHeader, returnMessage = pingHandler.handle if pingHandler.canHandle?
      rescue => e
        Rails.logger.error("Video::CaptureHandler: #{e}")
      end

      Rails.logger.debug("Video::CaptureHandler: Served header : #{returnHeader}")
      Rails.logger.debug("Video::CaptureHandler: Served message: #{returnMessage}")

      return returnHeader, returnMessage
    end
  end
end
