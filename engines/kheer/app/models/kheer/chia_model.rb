module Kheer
  class ChiaModel < ActiveRecord::Base
    serialize :detectable_ids, Array

    # Validations
    validates :name, presence: true
    validates :major_id, presence: true # When adding new type (e.g. Logo, Branded Item) of model
    validates :minor_id, presence: true # When adding a new class to model

    def state
      Kheer::ChiaModelStates.new(self)
    end

    def isMajor?
      self.minor_id == 0
    end
    def majorParent
      ChiaModel.where(major_id: self.major_id).where(minor_id: 0).first
    end
    def minorParent
      ChiaModel.where(major_id: self.major_id).where(minor_id: (self.minor_id - 1)).first
    end
    def minorChildren
      ChiaModel.where(major_id: self.major_id).order(minor_id: :asc) - [self]
    end

  end
end
