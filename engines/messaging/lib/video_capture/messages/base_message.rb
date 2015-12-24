module VideoCapture
  module Messages
    class BaseMessage
      CATEGORY = 'video_capture'

      attr_accessor :message

      def to_json
        @message.to_json
      end
      def to_s
        to_json.to_s
      end

    end
  end
end
