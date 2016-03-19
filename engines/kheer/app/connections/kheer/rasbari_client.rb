module Kheer
  class RasbariClient < Messaging::Connections::GenericClient
    attr_accessor :hostname

    def initialize(hostname)
      @hostname = hostname
      exchangeName = "#{Messaging.config.samosa.exchange}"
      responseRoutingKey = "#{Messaging.config.samosa.routing_keys.rasbari.client}.#{Process.pid}"
      machineRoutingKey = "#{Messaging.config.samosa.routing_keys.nimki.server}.#{hostname}"

      super(exchangeName, responseRoutingKey, machineRoutingKey)
      Rails.logger.info("Start RasbariClient for hostname: #{hostname}.#{Process.pid}")
    end

    def getState
      # prepare packets and send message
      header = Messaging::Messages::Header.statusRequest
      message = Messaging::Messages::Samosa::StateQuery.new(nil)
      rh, rm = call(header, message)
      if rh.isStatusSuccess?
        state = Messaging::States::Samosa::ChiaStates.new(rm.state)
        return state, rm.progress
      else
        return Messaging::States::Samosa::ChiaStates.unknown, "Unknown"
      end
    end

    # Model details
    def sendChiaDetails(chiaDetailsMessage)
      return sendData(chiaDetailsMessage)
    end

    def sendClipDetails(clipDetailsMessage)
      return sendData(clipDetailsMessage)
    end

    private
      def sendData(messageData)
        header = Messaging::Messages::Header.dataRequest
        message = messageData
        responseHeader, responseMessage = call(header, message)
        status = responseHeader.isDataSuccess?
        return status, responseMessage.trace
      end
  end
end
