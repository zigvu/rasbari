module Video
  module CaptureWorkflow
    class StartVncServer

      def initialize(capture)
        @capture = capture
      end

      def canSkip
        false
      end

      def serve
        true
      end

      def handle(params)
        status = false
        message = "Couldn't start VNC Server"

        if @capture.stream.state.isAtOrAfterReady? && @capture.captureClient.startVncServer
          status = true
          message = "Started VNC Server"
        end

        return status, message
      end

    end
  end
end
