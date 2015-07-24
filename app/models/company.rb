class Company < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :user
  belongs_to :company_field
  has_many :employees
  has_many :surveys
end
