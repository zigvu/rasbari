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
        status, trace = @capture.captureClient.isRemoteAlive?
        if status
          # set remote capture details
          status, trace = @capture.captureClient.sendCaptureDetails(@capture.toMessage)
          trace = "Capture remote is alive but couldn't set capture details" if !status
        end

        return status, trace
      end

    end
  end
end
