class OfficeLocation < ActiveRecord::Base
  has_many :employees
  belongs_to :company

  validates :country, :address, :city, presence: true
end
