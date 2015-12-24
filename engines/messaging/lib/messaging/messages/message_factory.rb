require 'json'

module Messaging
  module Messages
    class MessageFactory
      def self.categoriesNames
        # structure:
        # {category: [names], }
        {
          general: [:none, :error],
          video_capture: [:state_query]
        }
      end

      def self.getMessage(jsonMessage)
        message = Messaging::BaseLibs::DeepSymbolize.convert(JSON.parse(jsonMessage))

        # check if we have corresponding message
        cn = Messaging::Messages::MessageFactory.categoriesNames
        categorySym = message.category.to_sym
        nameSym = message.name.to_sym
        if !(cn[categorySym] && cn[categorySym].include?(nameSym))
          Messaging.logger.error("MessageFactory: Couldn't find message: categorySym: #{categorySym}, nameSym: #{nameSym}")
          raise "MessageFactory: Couldn't find message class for jsonMessage: #{jsonMessage}"
        end

        categorySym = message.category.split("_").map{ |s| s.capitalize }.join("")
        nameSym = message.name.split("_").map{ |s| s.capitalize }.join("")
        return Object.const_get("Messaging::Messages::#{categorySym}::#{nameSym}").new(message)
      end

      def self.getNoneMessage
        Messaging::Messages::General::None.new(nil)
      end

    end
  end
end
