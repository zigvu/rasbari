module Analysis
  class MdConfusionFinder
    include Mongoid::Document

    # format:
    # { filters: [
    #   {pri_det_id:, sec_det_id:, number_of_localizations:,
    #     selected_filters: {
    #       pri_prob:, pri_scales: [floats],
    #       sec_prob:, sec_scales: [floats],
    #       int_thresh: float
    #     }
    #   }
    # ]}
    field :cf, as: :confusion_filters, type: Hash

    embedded_in :mining, class_name: "Analysis::Mining"
  end
end
