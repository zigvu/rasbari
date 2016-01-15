module Messaging
  module Messages
    module VideoCapture

      class StateTransition < BaseMessage::Common
        ATTR = ["state"]
        zextend BaseMessage, ATTR

        def initialize(message = nil)
          super(_category, _name, message)
        end

        def getVideoCaptureState
          Messaging::States::VideoCapture::CaptureStates.new(@state)
        end

        private
          def _category
            __FILE__.split("/")[-2]
          end
          def _name
            File.basename(__FILE__, ".*")
          end
        # end private
      end

    end
  end
end
