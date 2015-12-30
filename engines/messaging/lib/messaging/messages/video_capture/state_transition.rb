module Messaging
  module Messages
    module VideoCapture

      class StateTransition < BaseMessage::Common
        CATEGORY = "video_capture"
        NAME = "state_transition"

        def self.attributes
          ["category", "name", "state"]
        end
        zextend BaseMessage, StateTransition.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

        def getVideoCaptureState
          Messaging::VideoCapture::CaptureStates.new(@state)
        end
      end

    end
  end
end
