module Kheer
  module IterationWorkflow
    class SelectDetectables
      attr_accessor :detectablesAnnoCnts, :selectedDetectableIds

      def initialize(iteration)
        @iteration = iteration
      end

      def canSkip
        @iteration.state.isAfterConfigured?
      end

      def serve
        currentCm = @iteration.chia_model
        ancCmIds = ChiaModel.where(major_id: currentCm.major_id).pluck(:id) - [currentCm.id]
        @detectablesAnnoCnts = ActiveSupport::OrderedHash.new
        Detectable.where(id: currentCm.detectable_ids).each do |det|
          @detectablesAnnoCnts[det] = {
            ancestor: Annotation.in(chia_model_id: ancCmIds)
                .where(detectable_id: det.id).count,
            current: Annotation.where(chia_model_id: currentCm.id)
                .where(detectable_id: det.id).count
          }
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
