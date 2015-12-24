require_relative 'base_message'

module Messaging
  module Messages
    module VideoCapture
      class StateQuery < Messaging::Messages::VideoCapture::BaseMessage
        NAME = 'state_query'

        def initialize(message = nil)
          @message = message || Messaging::BaseLibs::DeepSymbolize.convert({
            category: Messaging::Messages::VideoCapture::BaseMessage::CATEGORY,
            name: Messaging::Messages::VideoCapture::StateQuery::NAME,
            state: nil
          })
        end

        def getState
          Messaging::VideoCapture::CaptureStates.new(@message.state)
        end
        def setState(newState)
          @message.state = newState.to_s
        end
      end
    end
  end
end
