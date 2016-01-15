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
        # Note, unless exception, this will always succeed

        # if a capture machine has been set, need to release it gracefully
        if @capture.captureMachine
          # if we have started a capture client
          if @capture.captureClient
            # if we can ping then we can try to stop normally
            status, trace = @capture.captureClient.isRemoteAlive?
            if status
              @capture.captureClient.setStateStopped
            end # status
          end # captureClient
          @capture.captureMachine.state.setReady
        end # captureMachine

        @capture.stream.state.setStopped
        @capture.update(stopped_by: params[:current_user_id])
        @capture.update(stopped_at: Time.now)

        status = true
        trace = "Capture stopped"

        return status, trace
      end

    end
  end
end
