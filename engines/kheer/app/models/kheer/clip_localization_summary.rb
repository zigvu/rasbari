module Kheer
  class ClipLocalizationSummary
    include Mongoid::Document

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer
    field :cl, as: :clip_id, type: Integer
    field :ps, as: :prob_score, type: Float

    # count of locs with gte prob_score
    # -------------------------------------------
    # format:
    # {detectable_id: count, }
    field :cnt, as: :localization_counts, type: Hash

    # index for faster traversal during ordering
    # -------------------------------------------
    index({ chia_model_id: 1 }, { background: true })
    index({ clip_id: 1 }, { background: true })

  end
end
