module Kheer
  class DetectableAuthorizer < ::ApplicationAuthorizer
    def self.default(adjective, user)
      # admin has ability to manage detectables
      user.role.isAtLeastAdmin?
    end

    def self.readable_by?(user)
      # manager has ability to read detectables
      user.role.isAtLeastManager?
    end

  end
end
