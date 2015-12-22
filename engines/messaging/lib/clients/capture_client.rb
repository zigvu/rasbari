module Clients
  class CaptureClient
    def initialize(machineIp)
      @responseRoutingKey = "#{Messaging.video_capture_exchange}.rasbari"
      @machineRoutingKey = "#{Messaging.video_capture_exchange}.nimki.#{machineIp}"

      connection = $bunny_connection || Messaging.connection

      if Messaging.video_capture_client == nil
        Messaging.video_capture_client = Connections::RpcClient.new(
          connection,
          Messaging.video_capture_exchange,
          @responseRoutingKey
        )
      end
    end

    def call(header, message)
      Messaging.video_capture_client.call(@machineRoutingKey, header, message)
    end
  end
end
