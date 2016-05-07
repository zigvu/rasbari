module Analysis
  module ConfusionFinderJsonifier
    class HeatmapGenerator

      def initialize(mining)
        @mining = mining

        @chiaModelIdLoc = @mining.chia_model_id_loc
        chiaModelLoc = Kheer::ChiaModel.find(@chiaModelIdLoc)
        @detectableIds = chiaModelLoc.detectable_ids
        @clipIds = @mining.clip_ids
      end

      def setConditions(priProbs, priScales, secProbs, secScales, intThresh)
        @priProbs = priProbs
        @priScales = priScales
        @secProbs = secProbs
        @secScales = secScales
        @intThresh = intThresh
      end

      def formatted
        detectables = Kheer::Detectable.where(id: @detectableIds)

        # aggregate all count data
        counts = {}
        detectables.each do |pdi|
          counts[pdi.id] = {}
          detectables.each do |sdi|
            counts[pdi.id][sdi.id] = 0
          end
        end
        Kheer::ClipIntersectionSummary
          .where(chia_model_id: @chiaModelIdLoc)
          .in(clip_id: @clipIds)
          .gte(threshold: @intThresh)
          .in(primary_prob_score: @priProbs)
          .in(primary_scale: @priScales)
          .in(secondary_prob_score: @secProbs)
          .in(secondary_scale: @secScales).each do |cis|
          cis.confusion_counts.each do |pdi, pdiX|
            pdiX.each do |sdi, count|
              counts[pdi.to_i][sdi.to_i] += count
            end
          end
        end

        # format:
        # {intersections: , detectable_map:}
        # where intersections:
        # [{name:, row:, col:, value: count:}, ]
        intersections = []
        maxConfCount = 1
        detectables.each_with_index do |detRow, rowIdx|
          detectables.each_with_index do |detCol, colIdx|
            confCount = counts[detRow.id][detCol.id]
            # puts "[#{detRow.id}][#{detCol.id}] : #{confCount}" if confCount > 0
            intersections << {
              name: "#{detRow.pretty_name} [#{detRow.id}] :: #{detCol.pretty_name} [#{detCol.id}]",
              row: rowIdx,
              col: colIdx,
              value: 0,
              count: confCount
            }
            maxConfCount = [maxConfCount, confCount].max
          end # detCol
        end # detRow
        # update percentage
        intersections.each do |ra|
          ra[:value] = (1.0 * ra[:count] / maxConfCount).round(3)
        end
        # detectable map
        detectableIdNameMap = Hash[detectables.pluck(:id, :pretty_name)]
        return {
          intersections: intersections,
          detectable_map: detectableIdNameMap
        }
      end

    end
  end
end
