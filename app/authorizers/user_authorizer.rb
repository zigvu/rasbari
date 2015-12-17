class UserAuthorizer < ::ApplicationAuthorizer
  def self.default(adjective, user)
    # admin has ability to manage users
    user.role.isAtLeastAdmin?
  end

  def self.readable_by?(user)
    # manager has authority to see users
    user.role.isAtLeastManager?
  end

end
