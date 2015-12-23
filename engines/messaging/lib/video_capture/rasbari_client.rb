module VideoCapture
  class RasbariClient < Connections::GenericClient
    def initialize(hostname)
      exchangeName = "#{Messaging.config.video_capture.exchange}"
      responseRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.client}"
      machineRoutingKey = "#{Messaging.config.video_capture.routing_keys.nimki.server}.#{hostname}"

      super(exchangeName, responseRoutingKey, machineRoutingKey)
      Messaging.logger.info("Start RasbariClient for hostname: #{hostname}")
    end

  end
end
