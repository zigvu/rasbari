module Video
  module CaptureWorkflow
    class SetRemoteReady

      def initialize(capture)
        @capture = capture
      end

      def canSkip
        @capture.stream.state.isAtOrAfterReady?
      end

      def serve
        true
      end

      def handle(params)
        status, trace = @capture.captureClient.setStateReady

        if status
          status, trace = @capture.captureClient.startVncServer
          if status
            @capture.stream.state.setReady
            trace = "Started all remote capture processes including VNC server"
          end
        end

        return status, trace
      end

    end
  end
end
