module Analysis
  module SequenceViewerWorkflow
    class SetThresholds
      attr_reader :thresholds, :selectedThreshold

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        threshold = @mining.md_sequence_viewer.threshold
        detectableIds = @mining.md_sequence_viewer.detectable_ids
        chiaModel = Kheer::ChiaModel.find(@mining.chia_model_id_loc)

        @thresholds = []
        chiaModel.probThreshs.each do |th|
          locs = Kheer::Localization.gte(prob_score: th)
              .where(chia_model_id: @mining.chia_model_id_loc)
              .in(detectable_id: detectableIds)
              .in(clip_id: @mining.clip_ids).count
          @thresholds << {thresh: th, locs: locs}
        end
        @selectedThreshold = threshold.round(1) if threshold
      end

      def handle(params)
        status, trace = true, "Done"
        threshold = params["threshold"].to_f.round(1)
        status = @mining.md_sequence_viewer.update({threshold: threshold})
        return status, trace
      end

    end
  end
end
