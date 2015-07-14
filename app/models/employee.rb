class Employee < ActiveRecord::Base
  validates :name, :company_id, presence: true
  validates :name, uniqueness: true
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ } 

  belongs_to :company
end
