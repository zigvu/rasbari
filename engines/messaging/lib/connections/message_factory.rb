require 'json'

module Connections
  class MessageFactory

    def self.getMessage(jsonMessage)
      message = Messaging::DeepSymbolize.convert(JSON.parse(jsonMessage))

      # Video Capture
      if message.category == VideoCapture::Messages::BaseMessage::CATEGORY
        if message.name == VideoCapture::Messages::StateQuery::NAME
          return VideoCapture::Messages::StateQuery.new(message)
        end
      elsif message.category == "none"
        return Connections::MessageFactory.getNilMessage
      end

      # we should never reach here
      raise "Couldn't parse message"
    end

    def self.getNilMessage
      Messaging::DeepSymbolize.convert({ category: "none", name: "none" })
    end

  end
end
