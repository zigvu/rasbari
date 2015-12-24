module Messaging
  module VideoCapture
    class RasbariClient < Messaging::Connections::GenericClient

      def initialize(hostname)
        exchangeName = "#{Messaging.config.video_capture.exchange}"
        responseRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.client}"
        machineRoutingKey = "#{Messaging.config.video_capture.routing_keys.nimki.server}.#{hostname}"

        super(exchangeName, responseRoutingKey, machineRoutingKey)
        Messaging.logger.info("Start RasbariClient for hostname: #{hostname}")
      end

      def isStateReady?
        # prepare packets
        header = Messaging::Messages::Header.statusRequest
        message = Messaging::VideoCapture::Messages::StateQuery.new(nil)
        # send message
        responseHeader, response = call(header, message.to_json)
        # parse response
        responseMessage = Messaging::Messages::MessageFactory.getMessage(response)
        captureState = responseMessage.getState
        # check condition
        responseHeader.isStatusSuccess? && captureState.isReady?
      end
      def setStateReady
      end

      def isStateCapturing?
      end
      def setStateCapturing
      end

      def isStateStopped?
      end
      def setStateStopped
      end

    end
  end
end
