module Kheer
  module IterationWorkflow
    class PingNimki

      def initialize(iteration)
        @iteration = iteration
      end

      def canSkip
        @iteration.state.isAtOrAfterBuilding?
      end

      def serve
      end

      def handle(params)
        status, trace = @iteration.gpuClient.isRemoteAlive?
        if status
          # set remote capture details
          status, trace = @iteration.gpuClient.sendModelDetails(@iteration.toMessage)
          if status
            @iteration.state.setBuilding
          else
            trace = "GPU remote is alive but couldn't set model build details"
          end
        end

        return status, trace
      end

    end
  end
end
