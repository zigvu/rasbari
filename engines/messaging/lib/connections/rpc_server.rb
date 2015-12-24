# Note: Headers are exchanged as JSON objects but converted to Header object
# during API call to this file
# Messages are always shared as RAW data so need to be marshalled/unmarshalled
# outside of API call to this file

module Connections
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
        responseHeaders, responseMessage = @rpcHandlerObj.call(
          Messages::Header.new(properties.headers),
          payload
        )
        # once message is handled, send ack
        @channel.ack(delivery_info.delivery_tag)

        @exchange.publish(
        responseMessage,
          routing_key: properties.reply_to,
          correlation_id: properties.correlation_id,
          headers: responseHeaders.to_json
        )
      end
    end

  end
end
