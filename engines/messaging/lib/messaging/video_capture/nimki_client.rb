require 'socket'

module Messaging
  module VideoCapture
    class NimkiClient < Messaging::Connections::GenericClient

      def initialize
        hostname = Socket.gethostname

        exchangeName = "#{Messaging.config.video_capture.exchange}"
        responseRoutingKey = "#{Messaging.config.video_capture.routing_keys.nimki.client}.#{hostname}"
        machineRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.server}"

        super(exchangeName, responseRoutingKey, machineRoutingKey)
        Messaging.logger.info("Start NimkiClient for hostname: #{hostname}")
      end

    end
  end
end
