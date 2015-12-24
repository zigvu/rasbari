# Note: Headers are exchanged as JSON objects but converted to Header object
# during API call to this file
# Messages are always shared as RAW data so need to be marshalled/unmarshalled
# outside of API call to this file

module Messaging
  module Connections
    class RpcClient
      attr_accessor :response, :responseHeader, :correlationId
      attr_reader :lock, :condition

      def initialize(connection, exchangeName, responseRoutingKey)
        channel = connection.create_channel
        @exchange = channel.topic(exchangeName, durable: true)
        @responseRoutingKey = responseRoutingKey
        # temporary exclusive queue for client to accept messages
        replyQueue = channel.queue("", exclusive: true, auto_delete: true)
        replyQueue.bind(@exchange, routing_key: @responseRoutingKey)

        # for blocking mechanism
        @lock      = Mutex.new
        @condition = ConditionVariable.new
        that = self

        # in a separate thread listen for reply messages
        replyQueue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
          if properties[:correlation_id] == that.correlationId
            that.response = payload
            that.responseHeader = Messaging::Messages::Header.new(properties.headers)
            that.lock.synchronize{ that.condition.signal }
            channel.ack(delivery_info.delivery_tag)
          end
        end
      end

      def call(publishRoutingKey, header, message, timeout = nil)
        # if we are expecting that request could time out, we need to
        # set responses to nil from previous calls
        if timeout
          self.responseHeader = Messaging::Messages::Header.pingFailure
          self.response = ""
        end

        self.correlationId = SecureRandom.uuid
        # send message
        @exchange.publish(
          message,
          routing_key: publishRoutingKey,
          correlation_id: self.correlationId,
          reply_to: @responseRoutingKey,
          headers: header.to_json
        )
        # wait for reply
        if timeout
          lock.synchronize{ condition.wait(lock, timeout) }
        else
          lock.synchronize{ condition.wait(lock) }
        end
        # return reply
        return responseHeader, response
      end

    end
  end
end
