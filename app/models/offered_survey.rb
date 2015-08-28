class OfferedSurvey < ActiveRecord::Base
  validates :title, :type, presence: true
  has_many :sqa_assignments
  has_many :offered_questions, through: :sqa_assignments
end
