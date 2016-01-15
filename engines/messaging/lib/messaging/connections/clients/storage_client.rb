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

        def setClientDetails
          header = Messaging::Messages::Header.dataRequest
          message = Messaging::Messages::Storage::ClientDetails.new(nil)
          message.type = Messaging::States::Storage::ClientTypes.capture
          message.hostname = @hostname
          responseHeader, responseMessage = call(header, message)

          status = responseHeader.isDataSuccess?
          return status, responseMessage.trace
        end

        def saveFile(clientFilePath, serverFilePath)
          opType = Messaging::States::Storage::FileOperationTypes.put
          commonFileOps(clientFilePath, serverFilePath, opType)
        end

        def getFile(serverFilePath, clientFilePath)
          opType = Messaging::States::Storage::FileOperationTypes.get
          commonFileOps(clientFilePath, serverFilePath, opType)
        end

        def delete(serverFilePath)
          opType = Messaging::States::Storage::FileOperationTypes.delete
          commonFileOps(nil, serverFilePath, opType)
        end

        def closeConnection
          opType = Messaging::States::Storage::FileOperationTypes.closeConnection
          commonFileOps(nil, nil, opType)
        end

        def commonFileOps(clientFilePath, serverFilePath, opType)
          header = Messaging::Messages::Header.dataRequest
          message = Messaging::Messages::Storage::FileOperations.new(nil)
          message.hostname = @hostname
          message.type = opType
          message.clientFilePath = clientFilePath
          message.serverFilePath = serverFilePath
          responseHeader, responseMessage = call(header, message)

          status = responseHeader.isDataSuccess?
          return status, responseMessage.trace
        end

      end # StorageClient
    end # Clients
  end # Connections
end # Messaging
