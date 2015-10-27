class Result < ActiveRecord::Base
  has_many :answers
  belongs_to :company_survey
  belongs_to :employee
  belongs_to :offered_question

  accepts_nested_attributes_for :answers
end
