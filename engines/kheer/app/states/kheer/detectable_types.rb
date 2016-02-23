module Kheer
  class DetectableTypes < BaseAr::ArAccessor

    def self.types
      ["positive", "negative", "avoid"]
    end
    zextend BaseType, Kheer::DetectableTypes.types

    def initialize(detectable)
      super(detectable, :ztype)
    end

  end
end
