module Analysis
  module HeatmapJsonifier
    class ServeHeatmap

      def initialize(parsedFilter)
        @parsedFilter = parsedFilter
      end

      def generateQueries
        pf = @parsedFilter
        query = Kheer::Localization
            .where(chia_model_id: pf.chiaModelId)
            .where(clip_id: pf.clipId)
            .where(frame_number: pf.frameNumber)
            .where(detectable_id: pf.detectableId)
            .where(scale: pf.scale)
        query
      end

      def formatted
        # get all entries
        entries = generateQueries().pluck(:prob_score, :x, :y, :w, :h)
        # format into what js expects
        # [{prob_score: , x:, y:, w:, h:}, ]

        cells = []
        entries.each do |e|
          prob_score = e[0]
          x = e[1]
          y = e[2]
          w = e[3]
          h = e[4]

          cells << {prob_score: prob_score, x: x, y: y, w: w, h: h}
        end

        return cells
      end

    end
  end
end
