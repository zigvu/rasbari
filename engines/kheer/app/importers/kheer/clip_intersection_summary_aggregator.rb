require 'ostruct'

module Kheer
  class ClipIntersectionSummaryAggregator
    class ClipIntersectionSummaryDumper < Kheer::GenericDumper
      def initialize
        super('Kheer::ClipIntersectionSummary')
      end
      def canFlush?
        # cannot flush unless all frames in clips have been processed
        false
      end
    end

    attr_accessor :dumper, :counters

    def initialize(chiaModelId)
      @chiaModel = Kheer::ChiaModel.find(chiaModelId)
      # format follows fields in ClipIntersectionSummary:
      # {th: {pps: {psl: {sps: {ssl: {pdi: {sdi: count}}}}}}}
      @counters = {}
      clipSummaryLoop(:initcounters)
      @dumper = ClipIntersectionSummaryDumper.new
    end

    def initcounters(th, pps, psl, sps, ssl)
      c = @counters
      @chiaModel.detectable_ids.each do |pdi|
        @chiaModel.detectable_ids.each do |sdi|
          c[th] ||= {}
          c[th][pps] ||= {}
          c[th][pps][psl] ||= {}
          c[th][pps][psl][sps] ||= {}
          c[th][pps][psl][sps][ssl] ||= {}
          c[th][pps][psl][sps][ssl][pdi] ||= {}
          c[th][pps][psl][sps][ssl][pdi][sdi] = 0
        end
      end
    end

    def clipSummaryLoop(summaryFunc)
      @chiaModel.intThreshs.each do |th|
        @chiaModel.probThreshs.each do |pps|
          @chiaModel.scales.each do |psl|
            @chiaModel.probThreshs.each do |sps|
              @chiaModel.scales.each do |ssl|
                send(summaryFunc, th, pps, psl, sps, ssl)
              end
            end
          end
        end
      end
    end

    def addInter(inter)
      i = OpenStruct.new(inter)
      # puts "#{i.th},#{i.pps},#{i.psl},#{i.sps},#{i.ssl},#{i.pdi},#{i.sdi}"
      @counters[i.th][i.pps][i.psl][i.sps][i.ssl][i.pdi][i.sdi] += 1
    end

    def writeInterToDb(th, pps, psl, sps, ssl)
      count = 0
      c = @counters
      @chiaModel.detectable_ids.each do |pdi|
        @chiaModel.detectable_ids.each do |sdi|
          count += c[th][pps][psl][sps][ssl][pdi][sdi]
        end
      end
      @dumper.add({
        ci: @chiaModel.id, cl: @clipId, th: th,
        pps: pps, psl: psl, sps: sps, ssl: ssl,
        cnt: c[th][pps][psl][sps][ssl]
      }) if count > 0
    end

    def finalize(clipId)
      @clipId = clipId
      clipSummaryLoop(:writeInterToDb)
      @dumper.finalize
    end

    def roundup(num, exp = 0)
      multiplier = 10 ** exp
      ((num * multiplier).ceil).to_f/multiplier.to_f
    end

  end
end
