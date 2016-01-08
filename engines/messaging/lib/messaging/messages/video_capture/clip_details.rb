module Messaging
  module Messages
    module VideoCapture

      class ClipDetails < BaseMessage::Common
        CATEGORY = "video_capture"
        NAME = "clip_details"

        def self.attributes
          [
            "category", "name", "captureId", "ffmpegName", "clipId",
            "storageClipPath", "storageThumbnailPath"
          ]
        end
        zextend BaseMessage, ClipDetails.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

      end

    end
  end
end
