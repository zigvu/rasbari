module Connections
  class GenericClient
    attr_accessor :exchangeName, :responseRoutingKey, :machineRoutingKey
    attr_accessor :rpcClient

    def initialize(exchangeName, responseRoutingKey, machineRoutingKey)
      connection = $bunny_connection || Messaging.connection

      @exchangeName = exchangeName
      @responseRoutingKey = responseRoutingKey
      @machineRoutingKey = machineRoutingKey
      @rpcClient = Connections::RpcClient.new(connection, @exchangeName, @responseRoutingKey)
    end

    def call(header, message, timeout)
      @rpcClient.call(@machineRoutingKey, header, message, timeout)
    end

    # Common methods
    def isRemoteAlive?
      # timeout after 30 second of ping call
      rh, response = call(Messages::Header.ping, "", 30)
      rh.type.isTypePing? && rh.state.isStateSuccess?
    end


  end
end
