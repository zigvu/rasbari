require 'ostruct'

module Kheer
  class ClipLocalizationSummaryAggregator
    class ClipLocalizationSummaryDumper < Kheer::GenericDumper
      def initialize
        super('Kheer::ClipLocalizationSummary')
      end
      def canFlush?
        # cannot flush unless all frames in clips have been processed
        false
      end
    end

    attr_accessor :dumper, :counters

    def initialize(chiaModelId)
      @chiaModel = Kheer::ChiaModel.find(chiaModelId)
      # format follows fields in ClipLocalizationSummary:
      # {ps: {di: count, }, }
      @counters = {}
      clipSummaryLoop(:initcounters)
      @dumper = ClipLocalizationSummaryDumper.new
    end

    def initcounters(ps)
      c = @counters
      @chiaModel.detectable_ids.each do |di|
        c[ps] ||= {}
        c[ps][di] = 0
      end
    end

    def clipSummaryLoop(summaryFunc)
      @chiaModel.probThreshs.each do |ps|
        send(summaryFunc, ps)
      end
    end

    def addLoc(loc)
      l = OpenStruct.new(loc)
      # add to all lte ps
      @chiaModel.probThreshs.each do |ps|
        next if ps > l.ps
        @counters[ps][l.di] += 1
      end
    end

    def writeInterToDb(ps)
      count = 0
      c = @counters
      @chiaModel.detectable_ids.each do |di|
        count += c[ps][di]
      end
      @dumper.add({
        ci: @chiaModel.id, cl: @clipId, ps: ps, cnt: c[ps]
      }) if count > 0
    end

    def finalize(clipId)
      @clipId = clipId
      clipSummaryLoop(:writeInterToDb)
      @dumper.finalize
    end

  end
end
