module Analysis
  class MdSequenceViewer
    include Mongoid::Document

    field :th, as: :threshold, type: Float

    embedded_in :mining, class_name: "Analysis::Mining"
  end
end
