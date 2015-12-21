module Messaging
  class RpcServer

    def initialize(connection, exchangeName, listenRoutingKey, rpcHandlerObj)
      @channel = connection.create_channel
      @exchange = @channel.topic(exchangeName, :durable => true)
      # temporary exclusive queue for server to accept messages
      @serverQueue = @channel.queue("", exclusive: true, auto_delete: true)
      @serverQueue.bind(@exchange, routing_key: listenRoutingKey)

      @rpcHandlerObj = rpcHandlerObj
    end

    def start
      # need a non-blocking connection else rails won't load
      @serverQueue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
        responseHeaders, responseMessage = @rpcHandlerObj.call(properties.headers, payload)
        # once message is handled, sending ack
        @channel.ack(delivery_info.delivery_tag)

        @exchange.publish(responseMessage,
          routing_key: properties.reply_to,
          content_type: 'application/json',
          correlation_id: properties.correlation_id,
          headers: responseHeaders)
      end
    end

  end
end
