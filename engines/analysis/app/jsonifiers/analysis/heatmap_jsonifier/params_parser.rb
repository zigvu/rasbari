module Analysis
  module HeatmapJsonifier
    class ParamsParser

      attr_accessor :chiaModelId, :clipId, :frameNumber, :scale, :detectableId

      def initialize(heatmapParams)
        # expect: integer
        @chiaModelId = heatmapParams['chia_model_id'].to_i if heatmapParams['chia_model_id']
        # expect: integer
        @clipId = heatmapParams['clip_id'].to_i if heatmapParams['clip_id']
        # expect: integer
        @frameNumber = heatmapParams['clip_fn'].to_i if heatmapParams['clip_fn']
        # expect: float
        @scale = heatmapParams['scale'].to_f if heatmapParams['scale']
        # expect: integer
        @detectableId = heatmapParams['detectable_id'].to_i if heatmapParams['detectable_id']
      end

    end
  end
end
