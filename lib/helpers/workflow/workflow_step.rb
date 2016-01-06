module SampleEngine
  module TrackerWorkflow
    class XXX_REPLACE_STEP_CLASS_XXX

      def initialize(tracker)
        @tracker = tracker
      end

      def canSkip
        false
      end

      def serve
        true
      end

      def handle(params)
        status = false
        message = "Couldn't handle step"

        # TODO: change

        return status, message
      end

    end
  end
end
