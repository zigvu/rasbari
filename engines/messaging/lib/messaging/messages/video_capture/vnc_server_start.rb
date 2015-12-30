module Messaging
  module Messages
    module VideoCapture

      class VncServerStart < BaseMessage::Common
        CATEGORY = "video_capture"
        NAME = "vnc_server_start"

        def self.attributes
          ["category", "name"]
        end
        zextend BaseMessage, VncServerStart.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

      end

    end
  end
end
