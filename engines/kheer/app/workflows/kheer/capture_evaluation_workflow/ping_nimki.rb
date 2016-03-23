module Kheer
  module CaptureEvaluationWorkflow
    class PingNimki

      def initialize(capture_evaluation)
        @capture_evaluation = capture_evaluation
      end

      def canSkip
        @capture_evaluation.state.isAtOrAfterEvaluating?
      end

      def serve
      end

      def handle(params)
        status, trace = @capture_evaluation.samosaClient.isRemoteAlive?
        status, trace = @capture_evaluation.storageClient.isRemoteAlive? if status
        if status
          # save data
          ide = Kheer::CaptureEvaluationExporter.new(@capture_evaluation)
          ide.extract
          status, trace = @capture_evaluation.storageClient.saveFile(
            ide.tarFile, @capture_evaluation.testInputPath
          )
          if status
            ide.cleanup
            # set remote khajuri details
            status, trace = @capture_evaluation.samosaClient.sendKhajuriDetails(
              @capture_evaluation.decorate.toMessage
            )
            if status
              @capture_evaluation.state.setEvaluating
            else
              trace = "GPU remote is alive but couldn't set khajuri details"
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
