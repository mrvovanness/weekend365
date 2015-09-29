class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_one :company

  def is_admin?
    has_role? :admin
  end
end
