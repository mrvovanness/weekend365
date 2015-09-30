class CompanyField < ActiveRecord::Base
  has_many :companies
  translates :name
end
