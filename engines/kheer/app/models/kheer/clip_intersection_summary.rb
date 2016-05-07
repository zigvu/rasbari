module Kheer
  class ClipIntersectionSummary
    include Mongoid::Document

    # all float values are rounded to 1 decimal value

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer
    field :cl, as: :clip_id, type: Integer

    # filter
    # -------------------------------------------
    field :th, as: :threshold, type: Float
    field :pps, as: :primary_prob_score, type: Float
    field :psl, as: :primary_scale, type: Float
    field :sps, as: :secondary_prob_score, type: Float
    field :ssl, as: :secondary_scale, type: Float

    # counts
    # -------------------------------------------
    # format:
    # {primary_detectable_id: {secondary_detectable_id: count, }, }
    # or, shorthand: {pdi: {sdi: count, }, }
    field :cnt, as: :confusion_counts, type: Hash

    # index for faster traversal during ordering
    # -------------------------------------------
    index({ chia_model_id: 1 }, { background: true })
    index({ clip_id: 1 }, { background: true })

  end
end
