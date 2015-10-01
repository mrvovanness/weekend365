class Company < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :company_field
  has_many :employees, dependent: :destroy
  has_many :company_surveys, dependent: :destroy
  has_many :results, through: :employees
  has_many :users, inverse_of: :company, dependent: :destroy
end
