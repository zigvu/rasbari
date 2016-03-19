module Kheer
  class RasbariServer < Messaging::Connections::GenericServer

    def initialize(handler)
      exchangeName = "#{Messaging.config.samosa.exchange}"
      listenRoutingKey = "#{Messaging.config.samosa.routing_keys.rasbari.server}"

      super(exchangeName, listenRoutingKey, handler)
      Rails.logger.info("Start Kheer RasbariServer")
    end

  end
end
