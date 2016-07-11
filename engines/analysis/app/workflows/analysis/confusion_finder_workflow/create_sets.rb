module Analysis
  module ConfusionFinderWorkflow
    class CreateSets
      attr_reader :clipSets

      def initialize(mining)
        @mining = mining
        @chiaModelIdLoc = @mining.chia_model_id_loc
        @clipSetSize = 5
        @clipIds = @mining.clip_ids.sort
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
          filters = @mining.md_confusion_finder.confusion_filters[:filters]

          # format:
          # {clip_id: count}
          locCounts = {}
          filters.each do |filter|
            Kheer::ClipIntersectionSummary
              .where(chia_model_id: @chiaModelIdLoc)
              .in(clip_id: @clipIds)
              .gte(threshold: filter[:selected_filters][:int_thresh])
              .in(primary_prob_score: filter[:selected_filters][:pri_probs])
              .in(primary_scale: filter[:selected_filters][:pri_scales])
              .in(secondary_prob_score: filter[:selected_filters][:sec_probs])
              .in(secondary_scale: filter[:selected_filters][:sec_scales]).each do |cis|
                locCounts[cis.clip_id] ||= 0
                locCounts[cis.clip_id] += cis.confusion_counts[filter[:pri_det_id].to_s][filter[:sec_det_id].to_s]
            end
          end

          # format:
          # [{:clip_id, :loc_count, fn_count:}, ]
          clipIdLocCount = []
          @clipIds.each do |clipId|
            locCount = locCounts[clipId]

            next if !locCount || locCount <= 0
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
