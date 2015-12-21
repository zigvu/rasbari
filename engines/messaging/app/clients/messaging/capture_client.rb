module Messaging
  class CaptureClient
    def initialize(machineIp)
      @responseRoutingKey = "#{Messaging.video_capture_exchange}.rasbari"
      @machineRoutingKey = "#{Messaging.video_capture_exchange}.nimki.#{machineIp}"

      if Messaging.video_capture_client == nil
        Messaging.video_capture_client = Messaging::RpcClient.new(
          $bunny_connection,
          Messaging.video_capture_exchange,
          @responseRoutingKey
        )
      end
    end

    def call(message)
      Messaging.video_capture_client.call(@machineRoutingKey, message)
    end
  end
end
