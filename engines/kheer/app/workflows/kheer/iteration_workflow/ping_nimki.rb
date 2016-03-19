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
        status, trace = @iteration.samosaClient.isRemoteAlive?
        status, trace = @iteration.storageClient.isRemoteAlive? if status
        if status
          # save data
          ide = Kheer::IterationDataExporter.new(@iteration)
          ide.extract
          status, trace = @iteration.storageClient.saveFile(
            ide.tarFile, @iteration.buildInputPath
          )
          if status
            ide.cleanup
            # set remote chia details
            status, trace = @iteration.samosaClient.sendChiaDetails(@iteration.decorate.toMessage)
            if status
              @iteration.state.setBuilding
            else
              trace = "GPU remote is alive but couldn't set model build details"
            end
          else
            trace = "Could not contact storage server to save model build data"
          end
        end

        return status, trace
      end

    end
  end
end
