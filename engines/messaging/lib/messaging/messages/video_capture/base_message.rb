module Messaging
  module Messages
    module VideoCapture
      class BaseMessage
        CATEGORY = 'video_capture'

        attr_accessor :message

        def name; @message.name; end
        def category; @message.category; end

        def to_json; @message.to_json; end
        def to_s; to_json.to_s; end

      end
    end
  end
end
