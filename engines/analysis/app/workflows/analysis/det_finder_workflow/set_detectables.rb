module Analysis
  module DetFinderWorkflow
    class SetDetectables
      attr_reader :detDetails

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        chiaModel = Kheer::ChiaModel.find(@mining.chia_model_id_loc)
        scoreFilters = @mining.md_det_finder.score_filters || {}
        # aggregate all counts
        # format:
        # {ps: {di: count, }, }
        aggLocCounts = {}
        chiaModel.probThreshs.each do |ps|
          aggLocCounts[ps] ||= {}
          Kheer::ClipLocalizationSummary
            .where(chia_model_id: chiaModel.id)
            .in(clip_id: @mining.clip_ids)
            .where(prob_score: ps).each do |cls|
            cls.localization_counts.each do |di, count|
              aggLocCounts[ps][di.to_i] ||= 0
              aggLocCounts[ps][di.to_i] += count
            end
          end
        end

        # format:
        # {detId:, detName:, probCounts: [probCount, ], selProb: <probCount>}
        # where: probCount = ["probScore locCount", "probScore"]
        @detDetails = []
        ignoreProbCount = ["Ignore", -1.0]
        Kheer::Detectable.where(id: chiaModel.detectable_ids).each do |det|
          next if det.type.isAvoid?
          # count all locs
          probH = {}
          chiaModel.probThreshs.each do |ps|
            count = aggLocCounts[ps][det.id]
            probH[ps] = "#{ps} [#{count}]"
          end
          # selected prob, if any
          selP = scoreFilters[det.id.to_s]
          selProb = selP ? ["#{selP} [#{probH[selP]}]", selP] :  ignoreProbCount
          # construct select array
          probCounts = [ignoreProbCount]
          probH.each do |ps, cntTxt|
            probCounts << [cntTxt, ps]
          end
          @detDetails << {
            detId: det.id, detName: det.pretty_name,
            probCounts: probCounts, selProb: selProb
          }
        end
      end

      def handle(params)
        status, trace = true, "Done"
        sp = params[:det_ids].map{ |d,s| [d.to_i, s.to_f] if s.to_f > -1 } - [nil]
        selProbs = Hash[sp]
        status = @mining.md_det_finder.update(score_filters: selProbs)
        return status, trace
      end

    end
  end
end
