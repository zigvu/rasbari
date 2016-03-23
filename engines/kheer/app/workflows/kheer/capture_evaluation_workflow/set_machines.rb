module Kheer
  module CaptureEvaluationWorkflow
    class SetMachines
      attr_accessor :gpuMachines

      def initialize(capture_evaluation)
        @capture_evaluation = capture_evaluation
      end

      def canSkip
        @capture_evaluation.state.isAfterConfigured?
      end

      def serve
        @gpuMachines = Setting::Machine
          .where(ztype: Setting::MachineTypes.gpu)
          .where(zstate: Setting::MachineStates.ready)
          .pluck(:hostname, :id)
      end

      def handle(params)
        # prevent race condition when another user already assigned machine to another stream
        gpuMachineId = params['capture_evaluation']['gpu_machine_id'].to_i
        gpuMachine = Setting::Machine.find(gpuMachineId)
        status, trace = gpuMachine.state.isReady?

        if status
          @capture_evaluation.update({
            gpu_machine_id: gpuMachineId
          })
          gpuMachine.state.setContracted
          @capture_evaluation.state.setConfigured
          trace = "Saved machine states"
        end

        return status, trace
      end

    end
  end
end
