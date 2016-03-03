module Analysis
  class MiningTypes < BaseAr::ArAccessor

    def self.types
      ["sequenceViewer", "confusionFinder"]
    end
    zextend BaseType, Analysis::MiningTypes.types

    def initialize(mining)
      super(mining, :ztype)
    end

  end
end
