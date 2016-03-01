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
        @thresholds = []
        (0..10).map{ |i| (i * 0.1).round(1) }.each do |thresh|
          locs = Kheer::Localization.gte(prob_score: thresh)
              .where(chia_model_id: @mining.chia_model_id_loc)
              .in(clip_id: @mining.clip_ids).count
          @thresholds << {thresh: thresh, locs: locs}
        end
        @selectedThreshold = @mining.md_sequence_viewer.threshold.round(1)
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
