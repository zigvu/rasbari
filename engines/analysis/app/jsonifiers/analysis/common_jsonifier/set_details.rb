module Analysis
  module CommonJsonifier
    class SetDetails

      def initialize(mining, setId)
        @mining = mining
        @clipSet = @mining.clip_sets[setId.to_s]

        @chiaModelIdLoc = @mining.chia_model_id_loc
        @chiaModelIdAnno = @mining.chia_model_id_anno
        @chiaModelAnno = Kheer::ChiaModel.find(@chiaModelIdAnno)

        if @mining.type.isSequenceViewer?
          @selectedDetIds = [@chiaModelAnno.detectable_ids.first]
          @smartFilter = {spatial_intersection_thresh: 1.0}
        end
      end

      def getChiaModelFormatted(chiaModelId)
        # <chiaModel>: {
        #   id:, name:, settings: {zdistThresh: [zdistValue, ], scales: [scale, ]}
        # }
        cm = Kheer::ChiaModel.find(chiaModelId)
        return {
          id: cm.id, name: cm.name,
          settings: {zdistThresh: [0, 1, 2], scales: [1.0]}
        }
      end

      def getDetectablesFormattedLoc(chiaModelId)
        chiaModel = Kheer::ChiaModel.find(chiaModelId)
        detectableIds = chiaModel.detectable_ids
        getDetectablesFormatted(detectableIds)
      end

      def getDetectablesFormattedAnno(chiaModelId)
        chiaModel = Kheer::ChiaModel.find(chiaModelId)
        detectableIds = chiaModel.detectable_ids
        selDetIdsForAnno = @selectedDetIds.map{ |dId| dId if detectableIds.include?(dId) } - [nil]
        locsDets = getDetectablesFormatted(selDetIdsForAnno)
        locsAnno = getDetectablesFormatted(detectableIds - selDetIdsForAnno)
        locsDets + locsAnno
      end

      def getDetectablesFormatted(detectableIds)
        # <detectables>: [{id:, name:, pretty_name:}, ]
        detectables = []
        Kheer::Detectable.where(id: detectableIds).order(name: :asc).each do |det|
          detectables << {
            id: det.id,
            name: det.name,
            pretty_name: det.pretty_name
          }
        end
        detectables
      end

      def getClipsFormatted(clipSet)
        # <clip>: {clip_id:, clip_url:, clip_fn_start:, clip_fn_end:, length:,
        # playback_frame_rate:}
        clips = []
        clipSet.map{ |cls| cls["clip_id"]}.uniq.each do |cId|
          clip = Video::Clip.find(cId)
          clips << {
            clip_id: clip.id,
            clip_url: clip.clipPath,
            clip_fn_start: clip.frame_number_start,
            clip_fn_end: clip.frame_number_end,
            length: clip.length,
            playback_frame_rate: clip.capture.playback_frame_rate
          }
        end
        clips
      end

      def formatted
        # miningData: {
        #   chiaModels: {localization: <chiaModel>, annotation:<chiaModel>},
        #   detectables: {localization: <detectables>, annotation:<detectables>},
        #   clips: [<clip>, ],
        #   clipSet: [{clip_id:, other_unused:, }],
        #   selectedDetIds: [int, ]
        #   smartFilter: {spatial_intersection_thresh:,}
        # }
        return {
          chiaModels: {
            localization: getChiaModelFormatted(@chiaModelIdLoc),
            annotation:  getChiaModelFormatted(@chiaModelIdAnno)
          },
          detectables: {
            localization: getDetectablesFormattedLoc(@chiaModelIdLoc),
            annotation:  getDetectablesFormattedAnno(@chiaModelIdAnno)
          },
          clips: getClipsFormatted(@clipSet),
          clipSet: @clipSet,
          selectedDetIds: @selectedDetIds,
          smartFilter: @smartFilter,
        }
      end

    end
  end
end
