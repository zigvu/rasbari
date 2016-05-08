module Analysis
  class MdDetFinder
    include Mongoid::Document

    # format:
    # {detectable_id: prob_score, }
    field :sf, as: :score_filters, type: Hash

    embedded_in :mining, class_name: "Analysis::Mining"
  end
end
