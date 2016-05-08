module Analysis
  module DetFinderWorkflow
    class CreateSets
      attr_reader :clipSets

      def initialize(mining)
        @mining = mining
        @chiaModelIdLoc = @mining.chia_model_id_loc
        @clipSetSize = 5
      end

      def canSkip
        false
      end

      def serve
        @clipSets = getClipSets()
        @mining.update({clip_sets: @clipSets})
      end

      def handle(params)
        status, trace = true, "Done"
        @mining.clip_sets_progress = {}
        @mining.state.setCompleteSetup
        return status, trace
      end

      private
        def getClipSets
          clipIdLocCount = getClipIdLocCount()
          clipSets = {}

          curClipSetIdx = 0
          clipIdLocCount.each do |cll|
            clipSets[curClipSetIdx] ||= []
            clipSets[curClipSetIdx] << cll
            curClipSetIdx += 1 if clipSets[curClipSetIdx].count >= @clipSetSize
          end
          clipSets
        end

        def getClipIdLocCount
          scoreFilters = @mining.md_det_finder.score_filters

          # first, aggregate data across clips
          counts = {}
          scoreFilters.each do |detId, ps|
            Kheer::ClipLocalizationSummary
              .where(chia_model_id: @chiaModelIdLoc)
              .in(clip_id: @mining.clip_ids)
              .where(prob_score: ps).each do |cls|
              # add counts
              counts[cls.clip_id] ||= 0
              counts[cls.clip_id] += cls.localization_counts[detId.to_s]
            end
          end

          # format:
          # [{:clip_id, :loc_count, fn_count:}, ]
          clipIdLocCount = []
          @mining.clip_ids.sort.each do |clipId|
            locCount = counts[clipId]

            next if locCount <= 0
            clip = Video::Clip.find(clipId)
            fnCount = clip.frame_number_end - clip.frame_number_start

            clipIdLocCount << {
              clip_id: clipId,
              loc_count: locCount,
              fn_count: fnCount
            }
          end
          clipIdLocCount.sort_by{ |l| l[:loc_count] }.reverse
        end

    end
  end
end
