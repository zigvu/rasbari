module Video
  module CaptureWorkflow
    class SetDetails

      def initialize(capture)
        @capture = capture
      end

      def canSkip
        @capture.stream.state.isAfterConfiguring?
      end

      def serve
        true
      end

      def handle(params)
        status = false
        trace = "Couldn't save capture details to database"

        if @capture.update(params)
          status = true
          trace = "Saved capture details to database"
        end

        return status, trace
      end
    end
  end
end
