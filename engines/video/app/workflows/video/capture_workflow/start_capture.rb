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
        status, trace = @capture.captureClient.setStateCapturing

        if status
          @capture.stream.state.setCapturing
          @capture.update(started_by: params[:current_user_id])
          @capture.update(started_at: Time.now)
          @capture.captureMachine.state.setWorking
        else
          @capture.stream.state.setFailed
        end

        return status, trace
      end

    end
  end
end
