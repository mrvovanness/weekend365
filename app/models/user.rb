class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  validates :company, presence: true
  belongs_to :company, inverse_of: :users

  def is_admin?
    has_role? :admin
  end

  def is_usual?
    !has_role? :admin
  end
end
