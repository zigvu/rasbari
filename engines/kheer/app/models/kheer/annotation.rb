module Kheer
  class Annotation
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer

    field :cl, as: :clip_id, type: Integer
    field :fn, as: :frame_number, type: Integer

    field :at, as: :active, type: Boolean, default: true
    field :sct, as: :source_type, type: String # user or chiaModel
    field :sci, as: :source_id, type: String # userId or chiaModelId

    # annotation data
    # -------------------------------------------
    field :di, as: :detectable_id, type: Integer

    field :x0, type: Integer
    field :y0, type: Integer

    field :x1, type: Integer
    field :y1, type: Integer

    field :x2, type: Integer
    field :y2, type: Integer

    field :x3, type: Integer
    field :y3, type: Integer


    # index for faster traversal during ordering
    # -------------------------------------------
    index({ clip_id: 1 }, { background: true })
    index({ chia_model_id: 1 }, { background: true })
    index({ frame_number: 1 }, { background: true })

    # convenience methods
    # -------------------------------------------

    def sourceType
      return Kheer::AnnotationSourceTypes.new(self)
    end

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
