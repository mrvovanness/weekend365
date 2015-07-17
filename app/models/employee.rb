class Employee < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ } 

  belongs_to :company
end
