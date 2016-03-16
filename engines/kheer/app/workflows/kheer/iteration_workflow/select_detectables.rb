module Kheer
  module IterationWorkflow
    class SelectDetectables
      attr_accessor :detectablesAnnoCnts, :selectedDetectableIds

      def initialize(iteration)
        @iteration = iteration
      end

      def canSkip
        false
      end

      def serve
        ancestorChiaModelIds = ChiaModel.where(major_id: @iteration.chia_model.major_id).pluck(:id)
        @detectablesAnnoCnts = ActiveSupport::OrderedHash.new
        Detectable.where(id: @iteration.chia_model.detectable_ids).each do |det|
          @detectablesAnnoCnts[det] = Annotation.in(chia_model_id: ancestorChiaModelIds)
            .where(detectable_id: det.id).count
        end
        @selectedDetectableIds = @iteration.detectable_ids || []
      end

      def handle(params)
        trace = "Done"
        detectableIds = params["detectable_ids"].map{ |d| d.to_i }
        status = @iteration.update({detectable_ids: detectableIds})
        return status, trace
      end

    end
  end
end
