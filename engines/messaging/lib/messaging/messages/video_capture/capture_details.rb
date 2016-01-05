module Messaging
  module Messages
    module VideoCapture

      class CaptureDetails < BaseMessage::Common
        CATEGORY = "video_capture"
        NAME = "capture_details"

        def self.attributes
          [
            "category", "name", "captureId", "captureUrl", "width", "height",
            "playbackFrameRate", "storageHostname"
          ]
        end
        zextend BaseMessage, CaptureDetails.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

      end

    end
  end
end
