module Analysis
  module ConfusionFinderWorkflow
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
          clipIdLocCount = []
          filters = @mining.md_confusion_finder.confusion_filters[:filters]

          # format:
          # [{:clip_id, :loc_count, fn_count:}, ]
          @mining.clip_ids.sort.each do |clipId|
            locCount = 0
            filters.each do |filter|
              locCount += Kheer::Intersection
                  .where(chia_model_id: @chiaModelIdLoc)
                  .where(clip_id: clipId)
                  .where(primary_detectable_id: filter[:pri_det_id])
                  .where(secondary_detectable_id: filter[:sec_det_id])
                  .gte(primary_prob_score: filter[:selected_filters][:pri_prob])
                  .in(primary_scale: filter[:selected_filters][:pri_scales])
                  .gte(secondary_prob_score: filter[:selected_filters][:sec_prob])
                  .in(secondary_scale: filter[:selected_filters][:sec_scales])
                  .gte(threshold: filter[:selected_filters][:int_thresh])
                  .count
            end

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
