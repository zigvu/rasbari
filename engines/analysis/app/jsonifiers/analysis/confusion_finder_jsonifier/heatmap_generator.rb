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

      def setConditions(priZdist, priScales, secZdist, secScales, intThresh)
        @priZdist = priZdist
        @priScales = priScales
        @secZdist = secZdist
        @secScales = secScales
        @intThresh = intThresh
      end

      def formatted
        # format:
        # {intersections: , detectable_map:}
        # where intersections:
        # [{name:, row:, col:, value: count:}, ]
        intersections = []
        maxConfCount = 1
        detectables = Kheer::Detectable.where(id: @detectableIds)
        detectables.each_with_index do |detRow, rowIdx|
          detectables.each_with_index do |detCol, colIdx|
            confCount = Kheer::Intersection
                .where(chia_model_id: @chiaModelIdLoc)
                .in(clip_id: @clipIds)
                .gte(threshold: @intThresh)
                .where(primary_detectable_id: detRow.id)
                .gte(primary_zdist_thresh: @priZdist)
                .in(primary_scale: @priScales)
                .where(secondary_detectable_id: detCol.id)
                .gte(secondary_zdist_thresh: @secZdist)
                .in(secondary_scale: @secScales)
                .count
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
