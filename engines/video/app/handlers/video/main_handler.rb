module Video
  class MainHandler
    def initialize
    end

    def call(header, message)
      Rails.logger.debug("Video::MainHandler: Request header : #{header}")
      Rails.logger.debug("Video::MainHandler: Request message: #{message}")

      returnHeader = Messaging::Messages::Header.statusFailure
      returnMessage = Messaging::Messages::MessageFactory.getNoneMessage
      returnMessage.trace = "Message handler not found"

      begin
        pingHandler = Video::PingHandler.new(header, message)
        returnHeader, returnMessage = pingHandler.handle if pingHandler.canHandle?

        clipDetailsHandler = Video::ClipDetailsHandler.new(header, message)
        returnHeader, returnMessage = clipDetailsHandler.handle if clipDetailsHandler.canHandle?

      rescue Exception => e
        returnHeader = Messaging::Messages::Header.statusFailure
        returnMessage.trace = "Error: #{e.backtrace.first}"

        Rails.logger.error(e)
      end

      Rails.logger.debug("Video::MainHandler: Served header : #{returnHeader}")
      Rails.logger.debug("Video::MainHandler: Served message: #{returnMessage}")

      return returnHeader, returnMessage
    end
  end
end
