class User < ActiveRecord::Base
  # Devise token authentication for API
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :lockable
end
