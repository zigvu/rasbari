module Video
  class RasbariServer < Messaging::Connections::GenericServer

    def initialize(handler)
      exchangeName = "#{Messaging.config.video_capture.exchange}"
      listenRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.server}"

      super(exchangeName, listenRoutingKey, handler)
      Rails.logger.info("Start Video RasbariServer")
    end

  end
end
