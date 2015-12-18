module Video
  class Stream < ActiveRecord::Base
    # authorizer: current_user.can_read?(resource)
    include Authority::Abilities
    self.authorizer_name = 'Video::StreamAuthorizer'

    # Validations
    validates :name, presence: true
    validates :base_url, presence: true
    validates :stype, presence: true

    def state
      Video::StreamStates.new(self)
    end
    def type
      Video::StreamTypes.new(self)
    end
    def priority
      Video::StreamPriorities.new(self)
    end
  end
end
