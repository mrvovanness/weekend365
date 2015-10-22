class OfferedSurvey < ActiveRecord::Base
  validates :title, presence: true
  has_many :sqa_assignments, dependent: :destroy
  has_many :offered_questions, through: :sqa_assignments
  has_many :offered_answers, through: :sqa_assignments

  translates :title

  def ordered_by_topic_questions
    offered_questions.group_by { |question| question.topic }
      .delete_if { |topic| topic.empty? }
  end
end
