module Kheer
  module CaptureEvaluationWorkflow
    class SetDetails
      attr_accessor :captures, :chiaModelsHierarchy
      attr_accessor :selectedMiniId, :selectedMinorId, :selectedMajorId

      def initialize(capture_evaluation)
        @capture_evaluation = capture_evaluation
      end

      def canSkip
        @capture_evaluation.state.isAfterConfiguring?
      end

      def serve
        @captures = []
        Video::Capture.all.each do |capture|
          @captures << ["#{capture.stream.name} - #{capture.id} - #{capture.comment}", capture.id]
        end
        @chiaModelsHierarchy = Kheer::ChiaModel.hierarchy
        @selectedMiniId = @capture_evaluation.chia_model_id
        if @selectedMiniId
          selectedMini = Kheer::ChiaModel.find(@selectedMiniId)
          @selectedMinorId = selectedMini.decorate.minorParent.id
          @selectedMajorId = selectedMini.decorate.majorParent.id
        end
      end

      def handle(params)
        trace = "Done"
        captureId = params["capture_evaluation"]["capture_id"].to_i
        chiaModelId = params["chia_model_id_capEvaluation"].to_i
        status = @capture_evaluation.update({
          capture_id: captureId,
          chia_model_id: chiaModelId
        })
        if status
          @capture_evaluation.clip_evaluations.destroy_all
          @capture_evaluation.capture.clips.each do |clip|
            @capture_evaluation.clip_evaluations.create({
              clip_id: clip.id,
              zstate: Kheer::ClipEvaluationStates.configuring
            })
          end
        end
        return status, trace
      end

    end
  end
end
