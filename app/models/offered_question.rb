class OfferedQuestion < ActiveRecord::Base
  validates :title, presence: true

  has_and_belongs_to_many :company_surveys
  has_many :sqa_assignments
  has_many :offered_answers, through: :sqa_assignments
  has_many :offered_surveys, through: :sqa_assignments

  translates :title
end
