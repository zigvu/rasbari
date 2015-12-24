require_relative 'base_message'

module Messaging
  module Messages
    module General
      class None < Messaging::Messages::General::BaseMessage
        NAME = 'none'

        def initialize(message = nil)
          @message = message || Messaging::BaseLibs::DeepSymbolize.convert({
            category: Messaging::Messages::General::BaseMessage::CATEGORY,
            name: Messaging::Messages::General::None::NAME
          })
        end
      end
    end
  end
end
