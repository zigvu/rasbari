module Video
  module CaptureWorkflow
    class StopCapture

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
        message = "Couldn't stop capture"

        if @capture.captureClient.setStateStopped
          @capture.stream.state.setStopped
          @capture.update(stopped_by: params[:current_user_id])
          @capture.update(stopped_at: Time.now)
          @capture.captureMachine.state.setReady

          status = true
          message = "Capture stopped"
        end

        return status, message
      end

    end
  end
end
