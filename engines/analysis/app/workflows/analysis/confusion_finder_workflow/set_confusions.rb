module Analysis
  module ConfusionFinderWorkflow
    class SetConfusions
      attr_reader :probThreshs, :scales, :intThreshs

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        chiaModel = Kheer::ChiaModel.find(@mining.chia_model_id_loc)

        @probThreshs = chiaModel.probThreshs
        @scales = chiaModel.scales
        @intThreshs = chiaModel.intThreshs
      end

      def handle(params)
        status, trace = true, "Done"
        currentFilters = ActiveSupport::JSON.decode(params[:current_filters])
        status = @mining.md_confusion_finder.update(confusion_filters: {filters: currentFilters})
        return status, trace
      end

    end
  end
end
