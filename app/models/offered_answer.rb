class OfferedAnswer < ActiveRecord::Base
  validates :value, presence: true

  has_many :answers
  has_many :sqa_assignments, dependent: :destroy
  has_many :offered_questions, through: :sqa_assignments
  has_many :offered_surveys, through: :sqa_assignments
end
