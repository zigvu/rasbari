require 'json'

module Messaging
  module Messages
    class MessageFactory

      def self.getMessage(jsonMessage)
        message = Messaging::BaseLibs::DeepSymbolize.convert(JSON.parse(jsonMessage))

        # Video Capture
        if message.category == Messaging::VideoCapture::Messages::BaseMessage::CATEGORY
          if message.name == Messaging::VideoCapture::Messages::StateQuery::NAME
            return Messaging::VideoCapture::Messages::StateQuery.new(message)
          end
        elsif message.category == "none"
          return Messaging::Messages::MessageFactory.getNilMessage
        end

        # we should never reach here
        raise "Couldn't parse message"
      end

      def self.getNilMessage
        Messaging::BaseLibs::DeepSymbolize.convert({ category: "none", name: "none" })
      end

    end
  end
end
