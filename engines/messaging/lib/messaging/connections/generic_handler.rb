module Messaging
  module Connections
    class GenericHandler

      def handleGeneric(header)
        handled = false
        returnHeader = Messaging::Messages::Header.pingFailure
        returnMessage = Messaging::Messages::MessageFactory.getNoneMessage

        # if ping, ping back OK
        if header.type.isPing?
          handled = true
          returnHeader = Messaging::Messages::Header.pingSuccess
        end

        return handled, returnHeader, returnMessage
      end
    end
  end
end
