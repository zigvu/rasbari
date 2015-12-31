module Video
  class RasbariClient < Messaging::Connections::GenericClient
    attr_accessor :hostname

    def initialize(hostname)
      @hostname = hostname
      exchangeName = "#{Messaging.config.video_capture.exchange}"
      responseRoutingKey = "#{Messaging.config.video_capture.routing_keys.rasbari.client}"
      machineRoutingKey = "#{Messaging.config.video_capture.routing_keys.nimki.server}.#{hostname}"

      super(exchangeName, responseRoutingKey, machineRoutingKey)
      Rails.logger.info("Start RasbariClient for hostname: #{hostname}")
    end

    # States
    def isStateReady?
      responseHeader, response = getState()
      responseHeader.isStatusSuccess? && response.getVideoCaptureState.isReady?
    end
    def setStateReady
      responseHeader, response = setState(Messaging::States::VideoCapture::CaptureStates.ready)
      responseHeader.isDataSuccess? && response.getVideoCaptureState.isReady?
    end

    def isStateCapturing?
      responseHeader, response = getState()
      responseHeader.isStatusSuccess? && response.getVideoCaptureState.isCapturing?
    end
    def setStateCapturing
      responseHeader, response = setState(Messaging::States::VideoCapture::CaptureStates.capturing)
      responseHeader.isDataSuccess? && response.getVideoCaptureState.isCapturing?
    end

    def isStateStopped?
      responseHeader, response = getState()
      responseHeader.isStatusSuccess? && response.getVideoCaptureState.isStopped?
    end
    def setStateStopped
      responseHeader, response = setState(Messaging::States::VideoCapture::CaptureStates.stopped)
      responseHeader.isDataSuccess? && response.getVideoCaptureState.isStopped?
    end

    # Video details
    def sendCaptureDetails(captureDetailsMessage)
      header = Messaging::Messages::Header.dataRequest
      message = captureDetailsMessage
      responseHeader, response = call(header, message)
      responseHeader.isDataSuccess?
    end

    # VNC server start
    def startVncServer
      header = Messaging::Messages::Header.statusRequest
      message = Messaging::Messages::VideoCapture::VncServerStart.new(nil)
      responseHeader, response = call(header, message)
      responseHeader.isStatusSuccess?
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
        header = Messaging::Messages::Header.dataRequest
        message = Messaging::Messages::VideoCapture::StateTransition.new(nil)
        message.state = newState
        return call(header, message)
      end

  end
end
