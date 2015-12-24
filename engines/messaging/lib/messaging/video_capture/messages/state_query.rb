module Messaging
  module VideoCapture
    module Messages
      class StateQuery < Messaging::VideoCapture::Messages::BaseMessage
        NAME = 'state_query'

        def initialize(message = nil)
          @message = message || Messaging::BaseLibs::DeepSymbolize.convert({
            category: Messaging::VideoCapture::Messages::BaseMessage::CATEGORY,
            name: Messaging::VideoCapture::Messages::StateQuery::NAME,
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
