module Handlers
  class RpcHandler

    def handleGeneric(header)
      handled = false
      returnHeader = nil
      returnMessage = nil

      # if ping, ping back OK
      if header.type.isTypePing?
        handled = true
        returnHeader = Messages::Header.pingOk
        returnMessage = ""
      end

      return handled, returnHeader, returnMessage
    end
  end
end
