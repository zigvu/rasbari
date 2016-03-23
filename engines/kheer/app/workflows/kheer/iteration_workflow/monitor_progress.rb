module Kheer
  module IterationWorkflow
    class MonitorProgress
      attr_accessor :buildState, :buildProgress

      def initialize(iteration)
        @iteration = iteration
      end

      def canSkip
        false
      end

      def serve
        if @iteration.state.isAfterConfigured? && !@iteration.state.isBuilt?
          @buildState, @buildProgress = @iteration.samosaClient.getChiaState
          if @buildState.isBuilt?
            @iteration.state.setBuilt
            @iteration.gpuMachine.state.setReady
          end
        else
          @buildState = "Complete"
          @buildProgress = "100%"
        end
      end

      def handle(params)
        trace = "Waiting for model building to complete"
        status = false
        if @iteration.state.isBuilt?
          trace = "Model building complete"
          status = true
        end
        return status, trace
      end

    end
  end
end
