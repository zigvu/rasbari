module Analysis
  module SequenceViewerJsonifier
    class FullLocalizations

      def initialize(mining, setId)
        @mining = mining

        @chiaModelIdLoc = @mining.chia_model_id_loc
        chiaModelLoc = Kheer::ChiaModel.find(@chiaModelIdLoc)
        @detectableIds = chiaModelLoc.detectable_ids
        @threshold = @mining.md_sequence_viewer.threshold.round(1)

        clipSet = @mining.clip_sets[setId.to_s]
        @clipIds = clipSet.map{ |cs| cs["clip_id"].to_i }
      end

      def generateQueries
        # format [query]
        queries = []
        # since each clip will have a unique frame number, we can iterate
        # over clipIds rather than videoIds
        @clipIds.each do |clipId|
          @detectableIds.each do |detectableId|
            q = Kheer::Localization.where(clip_id: clipId)
                .where(chia_model_id: @chiaModelIdLoc)
                .where(detectable_id: detectableId)
                .gte(prob_score: @threshold)
            queries << q
          end
        end
        queries
      end

      def formatted
        # dataFullLocalizations: {:clip_id => {:clip_fn => {:detectable_id => [loclz]}}}
        #   where loclz: {chia_model_id:, zdist_thresh:, prob_score:, spatial_intersection:,
        #   scale: , x:, y:, w:, h:}
        @allFormattedLocs = {}

        @allFormattedLocs = {}
        queries = generateQueries()
        queries.each do |q|
          q.group_by(&:frame_number).each do |fn, localizations|
            localizations.each do |loclz|
              addLoclzToFormatted(loclz)
            end #localizations
          end #q
        end #queries
        @allFormattedLocs
      end

      def addLoclzToFormatted(loclz)
        clip_id = loclz.clip_id
        frame_number = loclz.frame_number
        detectable_id = loclz.detectable_id
        chia_model_id = loclz.chia_model_id
        zdist_thresh = loclz.zdist_thresh
        prob_score = loclz.prob_score
        spatial_intersection = 0.5
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
