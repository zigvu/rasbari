module Kheer
  class ChiaModel < ActiveRecord::Base
    serialize :detectable_ids, Array

    # Validations
    validates :name, presence: true
    validates :major_id, presence: true # When adding new type (e.g. Logo, Branded Item) of model
    validates :minor_id, presence: true # When adding a new class to model
    validates :mini_id, presence: true # When iterating on existing minor model

    def state
      Kheer::ChiaModelStates.new(self)
    end

  end
end
