module Admin
  class UserRoles < BaseRole::ArAccessor

    def self.roles
      ["guest", "trainee", "analyst", "manager", "admin", "superAdmin"]
    end
    zextend BaseRole, Admin::UserRoles.roles

    def initialize(user)
      super(Admin::UserRoles.roles, user, :srole)
    end

  end
end
