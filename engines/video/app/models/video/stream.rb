module Video
  class Stream < ActiveRecord::Base
    # authorizer: current_user.can_read?(resource)
    include Authority::Abilities
    self.authorizer_name = 'Video::StreamAuthorizer'
  end
end
