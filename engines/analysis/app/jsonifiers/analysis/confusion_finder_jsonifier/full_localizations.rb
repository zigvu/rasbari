module Analysis
  module ConfusionFinderJsonifier
    class FullLocalizations

      def initialize(mining, setId)
        @mining = mining

        @chiaModelIdLoc = @mining.chia_model_id_loc
        @filters = @mining.md_confusion_finder.confusion_filters[:filters]

        clipSet = @mining.clip_sets[setId.to_s]
        @clipIds = clipSet.map{ |cs| cs["clip_id"].to_i }
      end

      def generateQueries
        # format [query]
        queries = []
        @filters.each do |filter|
          q = Kheer::Intersection
              .where(chia_model_id: @chiaModelIdLoc)
              .in(clip_id: @clipIds)
              .where(primary_detectable_id: filter[:pri_det_id])
              .where(secondary_detectable_id: filter[:sec_det_id])
              .gte(primary_zdist_thresh: filter[:selected_filters][:pri_zdist])
              .in(primary_scale: filter[:selected_filters][:pri_scales])
              .gte(secondary_zdist_thresh: filter[:selected_filters][:sec_zdist])
              .in(secondary_scale: filter[:selected_filters][:sec_scales])
              .gte(threshold: filter[:selected_filters][:int_thresh])
          queries << q
        end
        queries
      end

      def formatted
        # dataFullLocalizations: {:clip_id => {:clip_fn => {:detectable_id => [loclz]}}}
        #   where loclz: {chia_model_id:, zdist_thresh:, prob_score:, spatial_intersection:,
        #   scale: , x:, y:, w:, h:}
        @allFormattedLocs = {}

        @allFormattedLocs = {}
        localizationIds = []
        queries = generateQueries()
        queries.each do |q|
          localizationIds += q.pluck(:localization_ids).flatten
          localizationIds.uniq!
        end #queries
        Kheer::Localization.in(id: localizationIds).each do |loclz|
          addLoclzToFormatted(loclz)
        end
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
