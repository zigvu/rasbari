module Kheer
  module CaptureEvaluationWorkflow
    class MonitorProgress
      attr_accessor :evaluationState
      attr_accessor :downloadedClipsNum, :evaluatedClipsNum, :queuedClipsNum
      attr_accessor :downloadedClipsPer, :evaluatedClipsPer, :queuedClipsPer

      def initialize(capture_evaluation)
        @capture_evaluation = capture_evaluation
      end

      def canSkip
        false
      end

      def serve
        if @capture_evaluation.state.isAfterConfigured? && !@capture_evaluation.state.isEvaluated?
          @evaluationState = @capture_evaluation.samosaClient.getKhajuriState
        else
          @evaluationState = "Complete"
        end
        # evaluation progress from decorator
      end

      def handle(params)
        trace = "Waiting for all clips to be evaluated"
        status = false
        if @capture_evaluation.state.isEvaluated?
          trace = "All clips evaluated"
          status = true
        end
        return status, trace
      end

    end
  end
end
