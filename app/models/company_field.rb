class CompanyField < ActiveRecord::Base
  has_many :companies, through: :companies_fields
end
