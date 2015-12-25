module Messaging
  module Messages
    module General

      class None < BaseMessage::Common
        CATEGORY = "general"
        NAME = "none"

        def self.attributes
          ["category", "name"]
        end
        zextend BaseMessage, None.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end
      end

    end
  end
end
