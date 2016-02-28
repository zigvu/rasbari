module Kheer
  class Intersection
    include Mongoid::Document

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer

    field :cl, as: :clip_id, type: Integer
    field :fn, as: :frame_number, type: Integer

    # intersection threshold
    # -------------------------------------------
    field :th, as: :threshold, type: Float

    # data denormalization for join-less query
    # -------------------------------------------
    field :pdi, as: :primary_detectable_id, type: Integer
    field :pps, as: :primary_prob_score, type: Float
    field :pzd, as: :primary_zdist_thresh, type: Float
    field :psl, as: :primary_scale, type: Float

    field :sdi, as: :secondary_detectable_id, type: Integer
    field :sps, as: :secondary_prob_score, type: Float
    field :szd, as: :secondary_zdist_thresh, type: Float
    field :ssl, as: :secondary_scale, type: Float

    # index for faster traversal during ordering
    # -------------------------------------------
    index({ chia_model_id: 1 }, { background: true })
    index({ clip_id: 1 }, { background: true })
    index({ frame_number: 1 }, { background: true })

    has_and_belongs_to_many :localizations, class_name: "Kheer::Localization", inverse_of: nil
  end
end
