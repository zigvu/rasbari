module Kheer
  class Detectable < ActiveRecord::Base
    # authorizer: current_user.can_read?(resource)
    include Authority::Abilities
    self.authorizer_name = 'Kheer::DetectableAuthorizer'

    # Validations
    validates :name, presence: true
    validates :pretty_name, presence: true
    validates :ztype, presence: true

    def type
      Kheer::DetectableTypes.new(self)
    end
  end
end
