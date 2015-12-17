class User < ActiveRecord::Base
  # authorizer: current_user.can_read?(resource)
  include Authority::UserAbilities
  # authorizer: user.readable_by(current_user)
  include Authority::Abilities

  # Devise token authentication for API
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :lockable

  # role
  def role
    Admin::UserRoles.new(self)
  end
end
