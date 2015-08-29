class ScaledAnswer < OfferedAnswer
  validates :value, presence: true
  has_many :sqa_assignments,
    foreign_key: :offered_answer_id,
    dependent: :destroy
  has_many :offered_questions, through: :sqa_assignments
  has_many :offered_surveys, through: :sqa_assignments
end
