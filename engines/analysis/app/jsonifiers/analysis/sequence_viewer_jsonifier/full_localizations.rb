module Analysis
  module SequenceViewerJsonifier
    class FullLocalizations

      def initialize(mining, setId)
        @mining = mining

        @chiaModelIdLoc = @mining.chia_model_id_loc
        @detectableIds = @mining.md_sequence_viewer.detectable_ids
        @threshold = @mining.md_sequence_viewer.threshold.round(1)

        clipSet = @mining.clip_sets[setId.to_s]
        @clipIds = clipSet.map{ |cs| cs["clip_id"].to_i }
      end

      def generateQuery
        query = Kheer::Localization
            .in(clip_id: @clipIds)
            .where(chia_model_id: @chiaModelIdLoc)
            .in(detectable_id: @detectableIds)
            .gte(prob_score: @threshold)
        query
      end

      def formatted
        # dataFullLocalizations: {:clip_id => {:clip_fn => {:detectable_id => [loclz]}}}
        #   where loclz: {chia_model_id:, zdist_thresh:, prob_score:, spatial_intersection:,
        #   scale: , x:, y:, w:, h:}
        @allFormattedLocs = {}

        @allFormattedLocs = {}
        query = generateQuery()
        query.each do |loclz|
          addLoclzToFormatted(loclz)
        end #query

        @allFormattedLocs
      end

      def addLoclzToFormatted(loclz)
        clip_id = loclz.clip_id
        frame_number = loclz.frame_number
        detectable_id = loclz.detectable_id
        chia_model_id = loclz.chia_model_id
        zdist_thresh = loclz.zdist_thresh
        prob_score = loclz.prob_score
        spatial_intersection = 1.0
        scale = loclz.scale
        x = loclz.x
        y = loclz.y
        w = loclz.w
        h = loclz.h

        @allFormattedLocs[clip_id] ||= {}
        @allFormattedLocs[clip_id][frame_number] ||= {}
        @allFormattedLocs[clip_id][frame_number][detectable_id] ||= []

        @allFormattedLocs[clip_id][frame_number][detectable_id] << {
          chia_model_id: chia_model_id,
          zdist_thresh: zdist_thresh, prob_score: prob_score,
          spatial_intersection: spatial_intersection,
          scale: scale, x: x, y: y, w: w, h: h
        }
      end

    end
  end
end
