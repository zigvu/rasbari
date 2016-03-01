module Analysis
  module SequenceViewerWorkflow
    class SetChiaVersions
      attr_reader :chiaModels

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        @chiaModels = Kheer::ChiaModel.all
      end

      def handle(params)
        trace = "Done"
        status = @mining.update({
          chia_model_id_loc: params['chia_model_id_loc'].to_i,
          chia_model_id_anno: params['chia_model_id_anno'].to_i
        })
        return status, trace
      end

    end
  end
end
