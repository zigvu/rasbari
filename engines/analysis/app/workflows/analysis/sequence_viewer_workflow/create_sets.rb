module Analysis
  module SequenceViewerWorkflow
    class CreateSets
      attr_reader :clipSets

      def initialize(mining)
        @mining = mining
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
          threshold = @mining.md_sequence_viewer.threshold.round(1)
          # format:
          # [{:clip_id, :loc_count, fn_count:}, ]
          @mining.clip_ids.sort.each do |clipId|
            clip = Video::Clip.find(clipId)
            locCount = Kheer::Localization.gte(prob_score: threshold)
                .where(chia_model_id: @mining.chia_model_id_loc)
                .where(clip_id: clipId).count
            fnCount = clip.frame_number_end - clip.frame_number_start

            clipIdLocCount << {
              clip_id: clipId,
              loc_count: locCount,
              fn_count: fnCount
            }
          end
          clipIdLocCount
        end

    end
  end
end
