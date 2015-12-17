# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    # superAdmin has full authority to everything
    user.role.isAtLeastSuperAdmin?
  end

  def self.readable_by?(user)
    # admin has read authority to everything
    user.role.isAtLeastAdmin?
  end

end
