module Analysis
  module CommonJsonifier
    class FullAnnotations

      def initialize(mining, setId)
        @mining = mining

        # select all chia models which have the same major parent as current one
        chiaModelIdAnno = @mining.chia_model_id_anno
        chiaModelAnno = Kheer::ChiaModel.find(chiaModelIdAnno)
        @allChiaModelIdAnnos = Kheer::ChiaModel.where(major_id: chiaModelAnno.major_id).pluck(:id)

        clipSet = @mining.clip_sets[setId.to_s]
        @clipIds = clipSet.map{ |cs| cs["clip_id"].to_i }
      end

      def generateQueries
        queries = []
        # get all annotations for clips in set
        queries << Kheer::Annotation.where(active: true)
          .in(chia_model_id: @allChiaModelIdAnnos)
          .in(clip_id: @clipIds)
        queries
      end

      def formatted
        # dataFullAnnotations: {:clip_id => {:clip_fn => {:detectable_id => [anno]}}}
        #   where anno: {chia_model_id:, source_type:, is_new:, x0:, y0:, x1:, y1:, x2:, y2:, x3:, y3}

        anno = {}
        queries = generateQueries()
        queries.each do |q|
          entries = q.pluck(
            :clip_id, :frame_number, :detectable_id, :chia_model_id, :source_type,
            :x0, :y0, :x1, :y1, :x2, :y2, :x3, :y3
          )
          entries.each do |e|
            clip_id = e[0]
            frame_number = e[1]
            detectable_id = e[2]
            chia_model_id = e[3]
            source_type = e[4]
            x0 = e[5]
            y0 = e[6]
            x1 = e[7]
            y1 = e[8]
            x2 = e[9]
            y2 = e[10]
            x3 = e[11]
            y3 = e[12]

            anno[clip_id] ||= {}
            anno[clip_id][frame_number] ||= {}
            anno[clip_id][frame_number][detectable_id] ||= []

            anno[clip_id][frame_number][detectable_id] << {
              chia_model_id: chia_model_id, source_type: source_type, is_new: false,
              x0: x0, y0: y0, x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3
            }
          end
        end
        anno
      end

    end
  end
end
