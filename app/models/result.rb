class Result < ActiveRecord::Base
  has_many :answers
  belongs_to :company_survey
end
