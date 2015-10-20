class CompanySurvey < ActiveRecord::Base
  validates :title, presence: true

  attr_accessor :skip_callback

  belongs_to :company
  has_one :email_schedule, dependent: :destroy
  has_many :results
  has_many :tokens
  has_many :answers, through: :results
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :offered_questions

  accepts_nested_attributes_for :email_schedule, allow_destroy: true

  def skip_callback?
    skip_callback
  end

  def started?
    counter > 0
  end

  def completed?
    number_of_repeats < counter
  end

  def daily?
    email_schedule.daily? if email_schedule
  end

  def weekly?
    email_schedule.weekly? if email_schedule
  end

  def get_statistics
    StatisticsService.new(self)
  end

  def get_charts
    ChartsService.new(self)
  end

  def start_at
    email_schedule.start_at if email_schedule
  end

  def number_of_repeats
    email_schedule.number_of_repeats if email_schedule
  end

  def repeat_every
    email_schedule.repeat_every if email_schedule
  end

  def finish_on
    email_schedule.finish_on if email_schedule
  end

  def next_delivery_at
    email_schedule.next_delivery_at if email_schedule
  end
end
