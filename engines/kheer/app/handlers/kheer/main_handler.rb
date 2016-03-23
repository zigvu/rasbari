module Kheer
  class MainHandler
    def initialize
    end

    def call(header, message)
      Rails.logger.debug("Kheer::MainHandler: Request header : #{header}")
      Rails.logger.debug("Kheer::MainHandler: Request message: #{message}")

      returnHeader = Messaging::Messages::Header.statusFailure
      returnMessage = Messaging::Messages::MessageFactory.getNoneMessage
      returnMessage.trace = "Message handler not found"

      begin
        pingHandler = Kheer::PingHandler.new(header, message)
        returnHeader, returnMessage = pingHandler.handle if pingHandler.canHandle?

        clipDetailsHandler = Kheer::ClipDetailsHandler.new(header, message)
        returnHeader, returnMessage = clipDetailsHandler.handle if clipDetailsHandler.canHandle?

        ceDetailsHandler = Kheer::ClipEvalDetailsHandler.new(header, message)
        returnHeader, returnMessage = ceDetailsHandler.handle if ceDetailsHandler.canHandle?

        chiaDetailsHandler = Kheer::ChiaDetailsHandler.new(header, message)
        returnHeader, returnMessage = chiaDetailsHandler.handle if chiaDetailsHandler.canHandle?

      rescue Exception => e
        returnHeader = Messaging::Messages::Header.statusFailure
        returnMessage.trace = "Error: #{e.backtrace.first}"

        Rails.logger.error(e)
      end

      Rails.logger.debug("Kheer::MainHandler: Served header : #{returnHeader}")
      Rails.logger.debug("Kheer::MainHandler: Served message: #{returnMessage}")

      return returnHeader, returnMessage
    end
  end
end
