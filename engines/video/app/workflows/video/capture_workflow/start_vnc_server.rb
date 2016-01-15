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
        trace = "Couldn't start VNC Server: Ensure remote is reachable"

        if @capture.stream.state.isAtOrAfterReady?
          status, trace = @capture.captureClient.startVncServer
        end

        return status, trace
      end

    end
  end
end
