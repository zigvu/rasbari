module Kheer
  class PingHandler
    def initialize(header, message)
      @header = header
      @message = message
    end

    def handle
      returnHeader = Messaging::Messages::Header.pingSuccess
      returnMessage = Messaging::Messages::MessageFactory.getNoneMessage
      return returnHeader, returnMessage
    end

    def canHandle?
      @header.type.isPing?
    end
  end
end
