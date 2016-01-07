require 'socket'

module Messaging
  module Connections
    module Clients
      class StorageClient < Messaging::Connections::GenericClient

        def initialize(serverHostname)
          @hostname = Socket.gethostname

          exchangeName = "#{Messaging.config.storage.exchange}"
          responseRoutingKey = "#{Messaging.config.storage.routing_keys.nimki.client}.#{@hostname}"
          machineRoutingKey = "#{Messaging.config.storage.routing_keys.nimki.server}.#{serverHostname}"

          super(exchangeName, responseRoutingKey, machineRoutingKey)
          Messaging.logger.info("Start StorageClient for hostname: #{@hostname}")
        end

        def setHostname(clientHostName)
          @hostname = clientHostName
        end

        def setClientDetails
          header = Messaging::Messages::Header.dataRequest
          message = Messaging::Messages::Storage::ClientDetails.new(nil)
          message.type = Messaging::States::Storage::ClientTypes.capture
          message.hostname = @hostname
          _, response = call(header, message)
          response
        end

        def saveFile(clientFilePath, serverFilePath)
          opType = Messaging::States::Storage::FileOperationTypes.put
          commonFileOps(clientFilePath, serverFilePath, opType)
        end

        def getFile(serverFilePath, clientFilePath)
          opType = Messaging::States::Storage::FileOperationTypes.get
          commonFileOps(clientFilePath, serverFilePath, opType)
        end

        def delete(serverFilePath, clientFilePath = nil)
          opType = Messaging::States::Storage::FileOperationTypes.delete
          commonFileOps(clientFilePath, serverFilePath, opType)
        end

        def commonFileOps(clientFilePath, serverFilePath, opType)
          header = Messaging::Messages::Header.dataRequest
          message = Messaging::Messages::Storage::FileOperations.new(nil)
          message.hostname = @hostname
          message.type = opType
          message.clientFilePath = clientFilePath
          message.serverFilePath = serverFilePath
          _, response = call(header, message)
          response
        end

      end # StorageClient
    end # Clients
  end # Connections
end # Messaging
