module Admin
  class Roles < BaseRole::ArAccessor

    def self.roles
      ["guest", "trainee", "analyst", "manager", "admin", "superAdmin"]
    end
    zextend BaseRole, Admin::Roles.roles

    def initialize(user)
      super(Admin::Roles.roles, user, :srole)
    end

  end
end
