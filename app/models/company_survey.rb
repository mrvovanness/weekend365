class CompanySurvey < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :company
  belongs_to :offered_survey
  has_one :email_schedule, dependent: :destroy
  has_many :results
  has_many :tokens
  has_many :answers, through: :results
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :offered_questions

  accepts_nested_attributes_for :email_schedule, allow_destroy: true
  accepts_nested_attributes_for :results, allow_destroy: true

  delegate :start_at,
    :number_of_repeats,
    :repeat_every,
    :finish_on,
    :next_delivery_at,
    :daily?,
    :weekly?,
    to: :email_schedule

  def started?
    counter > 0
  end

  def completed?
    number_of_repeats < counter
  end

  def get_statistics
    StatisticsService.new(self)
  end

  def get_charts
    ChartsService.new(self)
  end

  def ordered_by_topic_questions
    offered_questions.group_by { |question| question.topic }
      .delete_if { |topic| topic.try(:empty?) }
  end

  def unrepeatable?
    unless repeat.nil?
      !self.repeat
    else
      false
    end
  end

  def answered_by_web_form?
    offered_survey.try(:answers_through) == 'web'
  end
end
