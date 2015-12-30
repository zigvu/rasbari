require 'json'

module Messaging
  module Messages
    class MessageFactory

      def self.getMessage(jsonMessage)
        message = Messaging::BaseLibs::DeepSymbolize.convert(JSON.parse(jsonMessage))

        categorySym = message.category.split("_").map{ |s| s.capitalize }.join("")
        nameSym = message.name.split("_").map{ |s| s.capitalize }.join("")
        moduleName = "Messaging::Messages::#{categorySym}::#{nameSym}"
        if Object.const_defined?(moduleName)
          return Object.const_get(moduleName).new(message)
        end

        # Should not reach here
        Messaging.logger.error("MessageFactory: Couldn't find message: categorySym: #{categorySym}, nameSym: #{nameSym}")
        raise "MessageFactory: Couldn't find message class for jsonMessage: #{jsonMessage}"
      end

      def self.getNoneMessage
        Messaging::Messages::General::None.new(nil)
      end

    end
  end
end
