module Kheer
  class Iteration
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer
    field :dis, as: :detectable_ids, type: Array
    field :ui, as: :user_id, type: Integer

    field :st, as: :zstate, type: String
    field :tp, as: :ztype, type: String

    # index for faster traversal during ordering
    # -------------------------------------------
    index({ chia_model_id: 1 }, { background: true })

    # convenience methods
    # -------------------------------------------
    def state
      Kheer::IterationStates.new(self)
    end

    def type
      Kheer::IterationTypes.new(self)
    end

    def detectables
      return Detectable.find(self.detectable_ids)
    end

    def chia_model
      return ChiaModel.find(self.chia_model_id)
    end

  end
end
