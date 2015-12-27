module Admin
  class UserRoles < BaseAr::ArAccessor

    def self.roles
      ["guest", "trainee", "analyst", "manager", "admin", "superAdmin"]
    end
    zextend BaseRole, Admin::UserRoles.roles

    def initialize(user)
      super(user, :srole)
    end

  end
end
