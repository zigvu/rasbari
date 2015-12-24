module Connections
  class GenericHandler

    def handleGeneric(header)
      handled = false
      returnHeader = Messages::Header.pingFailure
      returnMessage = Connections::MessageFactory.getNilMessage

      # if ping, ping back OK
      if header.type.isPing?
        handled = true
        returnHeader = Messages::Header.pingSuccess
      end

      return handled, returnHeader, returnMessage
    end
  end
end
