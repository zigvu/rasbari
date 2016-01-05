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
        status = false
        message = "Couldn't start all remote capture processes"

        if @capture.captureClient.setStateReady
          message = "Remote capture processes started but couldn't start VNC server"

          if @capture.captureClient.startVncServer
            @capture.stream.state.setReady

            status = true
            message = "Started all remote capture processes including VNC server"
          end
        end

        return status, message
      end

    end
  end
end
