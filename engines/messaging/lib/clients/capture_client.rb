module Clients
  class CaptureClient
    def initialize(machineIp)
      @responseRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.client}"
      @machineRoutingKey = "#{Messaging.config.video_capture.routing_keys.nimki.server}.#{machineIp}"

      connection = $bunny_connection || Messaging.connection

      if Messaging.video_capture_client == nil
        Messaging.video_capture_client = Connections::RpcClient.new(
          connection,
          "#{Messaging.config.video_capture.exchange}",
          @responseRoutingKey
        )
      end
    end

    def call(header, message)
      Messaging.video_capture_client.call(@machineRoutingKey, header, message)
    end
  end
end
