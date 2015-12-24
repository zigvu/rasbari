module VideoCapture
  module Messages
    class StateQuery < VideoCapture::Messages::BaseMessage
      NAME = 'state_query'

      def initialize(message = nil)
        @message = message || Messaging::DeepSymbolize.convert({
          category: VideoCapture::Messages::BaseMessage::CATEGORY,
          name: VideoCapture::Messages::StateQuery::NAME,
          state: nil
        })
      end

      def getState
        VideoCapture::CaptureState.new(@message.state)
      end
      def setState(newState)
        @message.state = newState.to_s
      end
    end
  end
end
