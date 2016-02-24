module Kheer
  class AnnotationSourceTypes < BaseAr::ArAccessor

    def self.types
      ["user", "chiaModel"]
    end
    zextend BaseType, Kheer::AnnotationSourceTypes.types

    def initialize(annotation)
      super(annotation, :source_type)
    end

  end
end
