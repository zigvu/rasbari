module Kheer
  class IterationTypes < BaseAr::ArAccessor

    def self.types
      ["exhaustive", "quick"]
    end
    zextend BaseType, Kheer::IterationTypes.types

    def initialize(iteration)
      super(iteration, :ztype)
    end

  end
end
