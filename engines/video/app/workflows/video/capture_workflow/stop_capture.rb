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

        # if a capture machine has been set, need to release it gracefully
        if @capture.captureMachine
          # if we can ping then we can try to stop normally
          if @capture.captureClient && @capture.captureClient.isRemoteAlive?
            @capture.captureClient.setStateStopped
          end
          @capture.captureMachine.state.setReady
        end

        @capture.stream.state.setStopped
        @capture.update(stopped_by: params[:current_user_id])
        @capture.update(stopped_at: Time.now)

        status = true
        message = "Capture stopped"

        return status, message
      end

    end
  end
end
