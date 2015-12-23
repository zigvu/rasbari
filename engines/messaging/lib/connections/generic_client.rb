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

    def call(header, message, timeout = nil)
      @rpcClient.call(@machineRoutingKey, header, message, timeout)
    end

    # Common methods
    def isRemoteAlive?
      # timeout after 30 second of ping call
      responseHeader, response = call(Messages::Header.pingRequest, "", 30)
      responseHeader.isPingSuccess?
    end


  end
end
