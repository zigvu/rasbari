module Video
  class StreamAuthorizer < ::ApplicationAuthorizer
    def self.default(adjective, user)
      # manager has ability to manage streams
      user.role.isAtLeastManager?
    end

    def self.readable_by?(user)
      # analyst has ability to read streams
      user.role.isAtLeastAnalyst?
    end

  end
end
