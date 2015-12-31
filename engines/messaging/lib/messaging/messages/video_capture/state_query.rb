module Messaging
  module Messages
    module VideoCapture

      class StateQuery < BaseMessage::Common
        CATEGORY = "video_capture"
        NAME = "state_query"

        def self.attributes
          ["category", "name", "state"]
        end
        zextend BaseMessage, StateQuery.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

        def getVideoCaptureState
          Messaging::States::VideoCapture::CaptureStates.new(@state)
        end
      end

    end
  end
end
