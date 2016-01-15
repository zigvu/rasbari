module Video
  module CaptureWorkflow
    class SetMachines
      attr_reader :storageMachines, :captureMachines

      def initialize(capture)
        @capture = capture
      end

      def canSkip
        @capture.stream.state.isAfterConfiguring?
      end

      def serve
        @storageMachines = Setting::Machine
          .where(ztype: Setting::MachineTypes.storage)
          .where(zstate: Setting::MachineStates.ready)
          .pluck(:hostname, :id)
        @captureMachines = Setting::Machine
          .where(ztype: Setting::MachineTypes.capture)
          .where(zstate: Setting::MachineStates.ready)
          .pluck(:hostname, :id)
      end

      def handle(params)
        # prevent race condition when another user already assigned machine to another stream
        captureMachine = Setting::Machine.find(params[:capture_machine_id])
        status, trace = captureMachine.state.isReady?

        if status
          @capture.update(params)
          captureMachine.state.setContracted
          @capture.stream.state.setConfigured
          trace = "Saved machine states"
        end

        return status, trace
      end

    end
  end
end
