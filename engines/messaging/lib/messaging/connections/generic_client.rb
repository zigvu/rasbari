module Messaging
  module Connections
    class GenericClient
      attr_accessor :exchangeName, :responseRoutingKey, :machineRoutingKey
      attr_accessor :rpcClient

      def initialize(exchangeName, responseRoutingKey, machineRoutingKey)
        connection = $bunny_connection || Messaging.connection

        @exchangeName = exchangeName
        @responseRoutingKey = responseRoutingKey
        @machineRoutingKey = machineRoutingKey
        @rpcClient = Messaging::Connections::RpcClient.new(
          connection,
          @exchangeName,
          @responseRoutingKey
        )
      end

      def call(header, message, timeout = nil)
        # wait no more than 30 minute
        timeout ||= 30 * 60
        @rpcClient.call(@machineRoutingKey, header, message, timeout)
      end

      # Common methods
      def isRemoteAlive?
        header = Messaging::Messages::Header.pingRequest
        message = Messaging::Messages::MessageFactory.getNoneMessage
        # timeout after 30 second of ping call
        timeout = 30
        responseHeader, _ = call(header, message, timeout)
        responseHeader.isPingSuccess?
      end


    end
  end
end
