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
        status = false
        message = "Couldn't set machine roles - check if machines still in ready state"

        # prevent race condition when another user already assigned machine to another stream
        captureMachine = Setting::Machine.find(params[:capture_machine_id])
        if captureMachine.state.isReady? && @capture.update(params)
          captureMachine.state.setContracted
          @capture.stream.state.setConfigured

          status = true
          message = "Saved machine states"
        end

        return status, message
      end

    end
  end
end
