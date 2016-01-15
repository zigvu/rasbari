module Video
  class RasbariClient < Messaging::Connections::GenericClient
    attr_accessor :hostname

    def initialize(hostname)
      @hostname = hostname
      exchangeName = "#{Messaging.config.video_capture.exchange}"
      responseRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.client}.#{Process.pid}"
      machineRoutingKey = "#{Messaging.config.video_capture.routing_keys.nimki.server}.#{hostname}"

      super(exchangeName, responseRoutingKey, machineRoutingKey)
      Rails.logger.info("Start RasbariClient for hostname: #{hostname}.#{Process.pid}")
    end

    # States
    def isStateReady?
      responseHeader, responseMessage = getState()
      status = responseHeader.isStatusSuccess? && responseMessage.getVideoCaptureState.isReady?
      return status, responseMessage.trace
    end
    def setStateReady
      responseHeader, responseMessage = setState(Messaging::States::VideoCapture::CaptureStates.ready)
      status = responseHeader.isStatusSuccess? && responseMessage.getVideoCaptureState.isReady?
      return status, responseMessage.trace
    end

    def isStateCapturing?
      responseHeader, responseMessage = getState()
      status = responseHeader.isStatusSuccess? && responseMessage.getVideoCaptureState.isCapturing?
      return status, responseMessage.trace
    end
    def setStateCapturing
      responseHeader, responseMessage = setState(Messaging::States::VideoCapture::CaptureStates.capturing)
      status = responseHeader.isStatusSuccess? && responseMessage.getVideoCaptureState.isCapturing?
      return status, responseMessage.trace
    end

    def isStateStopped?
      responseHeader, responseMessage = getState()
      status = responseHeader.isStatusSuccess? && responseMessage.getVideoCaptureState.isStopped?
      return status, responseMessage.trace
    end
    def setStateStopped
      responseHeader, responseMessage = setState(Messaging::States::VideoCapture::CaptureStates.stopped)
      status = responseHeader.isStatusSuccess? && responseMessage.getVideoCaptureState.isStopped?
      return status, responseMessage.trace
    end

    # Video details
    def sendCaptureDetails(captureDetailsMessage)
      header = Messaging::Messages::Header.dataRequest
      message = captureDetailsMessage
      responseHeader, responseMessage = call(header, message)
      status = responseHeader.isDataSuccess?
      return status, responseMessage.trace
    end

    # VNC server start
    def startVncServer
      header = Messaging::Messages::Header.statusRequest
      message = Messaging::Messages::VideoCapture::VncServerStart.new(nil)
      responseHeader, responseMessage = call(header, message)
      status = responseHeader.isStatusSuccess?
      return status, responseMessage.trace
    end

    private
      def getState
        # prepare packets and send message
        header = Messaging::Messages::Header.statusRequest
        message = Messaging::Messages::VideoCapture::StateQuery.new(nil)
        return call(header, message)
      end
      def setState(newState)
        # prepare packets and send message
        header = Messaging::Messages::Header.statusRequest
        message = Messaging::Messages::VideoCapture::StateTransition.new(nil)
        message.state = newState
        return call(header, message)
      end

  end
end
