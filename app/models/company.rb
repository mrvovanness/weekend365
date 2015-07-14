class Company < ActiveRecord::Base
  validates :name, :field, presence: true
  belongs_to :user
  has_many :employees
end
