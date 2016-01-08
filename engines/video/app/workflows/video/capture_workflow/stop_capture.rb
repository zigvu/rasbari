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

        # if we can ping then we can try to stop normally
        if @capture.captureClient && @capture.captureClient.isRemoteAlive?
          @capture.captureClient.setStateStopped
        end

        @capture.stream.state.setStopped
        @capture.update(stopped_by: params[:current_user_id])
        @capture.update(stopped_at: Time.now)
        @capture.captureMachine.state.setReady if @capture.captureMachine

        status = true
        message = "Capture stopped"

        return status, message
      end

    end
  end
end
