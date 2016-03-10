module Kheer
  class Localization
    include Mongoid::Document

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer

    field :cl, as: :clip_id, type: Integer
    field :fn, as: :frame_number, type: Integer

    # if used in annotation - set default value during object creation
    # re: mongoid behavior: default scope overrides default value setting
    field :isa, as: :is_annotation, type: Boolean

    # scores
    # -------------------------------------------
    field :di, as: :detectable_id, type: Integer

    field :ps, as: :prob_score, type: Float
    field :zd, as: :zdist_thresh, type: Float
    field :sl, as: :scale, type: Float

    field :x, type: Integer
    field :y, type: Integer
    field :w, type: Integer
    field :h, type: Integer


    # index for faster traversal during ordering
    # -------------------------------------------
    index({ chia_model_id: 1 }, { background: true })
    index({ clip_id: 1 }, { background: true })
    index({ frame_number: 1 }, { background: true })

    # default scope
    # -------------------------------------------
    default_scope ->{ where(isa: false) }

    # convenience methods
    # -------------------------------------------
    def detectable
      return Detectable.find(self.detectable_id)
    end

    def clip
      return Video::Clip.find(self.clip_id)
    end

    def chiaModel
      return ChiaModel.find(self.chia_model_id)
    end
  end
end
