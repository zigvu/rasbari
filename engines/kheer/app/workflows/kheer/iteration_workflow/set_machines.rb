module Kheer
  module IterationWorkflow
    class SetMachines
      attr_accessor :gpuMachines

      def initialize(iteration)
        @iteration = iteration
      end

      def canSkip
        @iteration.state.isAfterConfiguring?
      end

      def serve
        @gpuMachines = Setting::Machine
          .where(ztype: Setting::MachineTypes.gpu)
          .where(zstate: Setting::MachineStates.ready)
          .pluck(:hostname, :id)
      end

      def handle(params)
        # prevent race condition when another user already assigned machine to another stream
        gpuMachineId = params['gpu_machine_id'].to_i
        gpuMachine = Setting::Machine.find(gpuMachineId)
        status, trace = gpuMachine.state.isReady?

        if status
          @iteration.update({gpu_machine_id: gpuMachineId})
          gpuMachine.state.setContracted
          @iteration.state.setConfigured
          trace = "Saved machine states"
        end

        return status, trace
      end

    end
  end
end
