class Company < ActiveRecord::Base
  validates :name, :user_id, presence: true
  belongs_to :user
  belongs_to :company_field
  has_many :employees, dependent: :destroy
  has_many :company_surveys, dependent: :destroy
  has_many :results, through: :employees
end
