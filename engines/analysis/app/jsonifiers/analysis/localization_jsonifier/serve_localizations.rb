module Analysis
  module LocalizationJsonifier
    class ServeLocalizations

      def initialize(parsedFilter)
        @parsedFilter = parsedFilter
      end

      def generateQueries
        pf = @parsedFilter
        query = Kheer::Localization
        query = query.where(chia_model_id: pf.chiaModelId) if pf.chiaModelId != nil
        query = query.where(clip_id: pf.clipId) if pf.clipId != nil
        query = query.where(frame_number: pf.frameNumber) if pf.frameNumber != nil
        query = query.gte(zdist_thresh: pf.zdistThresh) if pf.zdistThresh != nil
        query
      end

      def formatted
        # get all entries
        entries = generateQueries().pluck(
          :clip_id, :frame_number, :detectable_id, :chia_model_id,
          :zdist_thresh, :scale, :prob_score,
          :x, :y, :w, :h)
        # format into what js expects
        # localizations: {:clip_id => {:clip_fn => {:detectable_id => [loclz]}}}
        #   where loclz: {chia_model_id:, zdist_thresh:, prob_score:, spatial_intersection:,
        #   scale: , x:, y:, w:, h:}
        # }

        loc = {}
        entries.each do |e|
          clip_id = e[0]
          frame_number = e[1]
          detectable_id = e[2]
          chia_model_id = e[3]
          zdist_thresh = e[4]
          scale = e[5]
          prob_score = e[6]
          x = e[7]
          y = e[8]
          w = e[9]
          h = e[10]

          loc[clip_id] ||= {}
          loc[clip_id][frame_number] ||= {}
          loc[clip_id][frame_number][detectable_id] ||= []

          loc[clip_id][frame_number][detectable_id] << {
            chia_model_id: chia_model_id, zdist_thresh: zdist_thresh,
            prob_score: prob_score, spatial_intersection: 0,
            scale: scale, x: x, y: y, w: w, h: h
          }
        end

        return {localizations: loc}
      end

    end
  end
end
