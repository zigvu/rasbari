module Kheer
  module IterationWorkflow
    class SelectNumIters

      def initialize(iteration)
        @iteration = iteration
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
