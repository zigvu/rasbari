module Analysis
  module ClusterFinderWorkflow
    class SetDetectables
      attr_reader :detectables, :selectedDetectableIds

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        chiaModel = Kheer::ChiaModel.find(@mining.chia_model_id_loc)
        @detectables = Kheer::Detectable.where(id: chiaModel.detectable_ids)
        @selectedDetectableIds = @mining.md_sequence_viewer.detectable_ids || []
      end

      def handle(params)
        trace = "Done"
        detectableIds = params["detectable_ids"].map{ |d| d.to_i }
        status = @mining.md_sequence_viewer.update({detectable_ids: detectableIds})
        return status, trace
      end

    end
  end
end
