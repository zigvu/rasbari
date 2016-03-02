module Analysis
  module LocalizationJsonifier
    class ParamsParser

      attr_accessor :chiaModelId, :clipId, :frameNumber, :zdistThresh

      def initialize(localizationParams)
        # expect: integer
        @chiaModelId = localizationParams['chia_model_id'].to_i if localizationParams['chia_model_id']
        # expect: integer
        @clipId = localizationParams['clip_id'].to_i if localizationParams['clip_id']
        # expect: integer
        @frameNumber = localizationParams['clip_fn'].to_i if localizationParams['clip_fn']
        # expect: float
        @zdistThresh = localizationParams['zdist_thresh'].to_f if localizationParams['zdist_thresh']
      end

    end
  end
end
