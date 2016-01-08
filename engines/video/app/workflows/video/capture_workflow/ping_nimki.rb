module Video
  module CaptureWorkflow
    class PingNimki

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
        message = "Couldn't ping machines"

        if @capture.captureClient.isRemoteAlive?
          message = "Capture remote is alive but couldn't set capture details"
          # set remote capture details
          if @capture.captureClient.sendCaptureDetails(@capture.toMessage)
            status = true
            message = "Remote is alive and able to set capture details"
          end
        end

        return status, message
      end

    end
  end
end
