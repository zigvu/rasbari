module Video
  module CaptureWorkflow
    class StartCapture

      def initialize(capture)
        @capture = capture
      end

      def canSkip
        @capture.stream.state.isAtOrAfterCapturing?
      end

      def serve
        true
      end

      def handle(params)
        status = false
        message = "Couldn't start capture"

        if @capture.captureClient.setStateCapturing
          @capture.stream.state.setCapturing
          @capture.update(started_by: params[:current_user_id])
          @capture.update(started_at: Time.now)
          @capture.captureMachine.state.setWorking

          status = true
          message = "Capture started"
        else
          @capture.stream.state.setFailed
        end

        return status, message
      end

    end
  end
end
