class Employee < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ } 

  belongs_to :company
end
