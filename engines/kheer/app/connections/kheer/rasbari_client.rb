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

    # Khajuri related
    def getKhajuriState
      rh, rm = stateQuery
      if rh.isStatusSuccess?
        return Messaging::States::Samosa::KhajuriStates.new(rm.state)
      else
        return Messaging::States::Samosa::KhajuriStates.unknown
      end
    end

    def sendKhajuriDetails(khajuriDetailsMessage)
      return sendData(khajuriDetailsMessage)
    end

    # Chia related
    def getChiaState
      rh, rm = stateQuery
      if rh.isStatusSuccess?
        state = Messaging::States::Samosa::ChiaStates.new(rm.state)
        return state, rm.progress
      else
        return Messaging::States::Samosa::ChiaStates.unknown, "Unknown"
      end
    end

    def sendChiaDetails(chiaDetailsMessage)
      return sendData(chiaDetailsMessage)
    end

    # Common
    def sendClipDetails(clipDetailsMessage)
      return sendData(clipDetailsMessage)
    end

    private
      def stateQuery
        # prepare packets and send message
        header = Messaging::Messages::Header.statusRequest
        message = Messaging::Messages::Samosa::StateQuery.new(nil)
        return call(header, message)
      end

      def sendData(messageData)
        header = Messaging::Messages::Header.dataRequest
        message = messageData
        responseHeader, responseMessage = call(header, message)
        status = responseHeader.isDataSuccess?
        return status, responseMessage.trace
      end
  end
end
