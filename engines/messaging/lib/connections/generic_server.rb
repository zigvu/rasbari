module Connections
  class GenericServer
    attr_accessor :exchangeName, :listenRoutingKey, :handler
    attr_accessor :rpcServer

    def initialize(exchangeName, listenRoutingKey, handler)
      connection = $bunny_connection || Messaging.connection

      @exchangeName = exchangeName
      @listenRoutingKey = listenRoutingKey
      @handler = handler

      @rpcServer = Connections::RpcServer.new(
        connection,
        @exchangeName,
        @listenRoutingKey,
        @handler
      )
      @rpcServer.start
    end

  end
end
