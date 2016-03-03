module Analysis
  module ConfusionFinderWorkflow
    class SetConfusions
      attr_reader :zdistThreshs, :scales, :intThreshs

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        @zdistThreshs = [0, 1, 2]
        @scales = [1.0]
        @intThreshs = (0..10).map{ |i| (i * 0.1).round(1) }
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
