module Analysis
  class MdClusterFinder
    include Mongoid::Document

    field :th, as: :threshold, type: Float
    field :dis, as: :detectable_ids, type: Array

    embedded_in :mining, class_name: "Analysis::Mining"
  end
end
