class CompanySurvey < ActiveRecord::Base
  validates :title, :start_at, :message, presence: true
  validate :start_in_future?, :finish_after_start?, unless: :skip_callback?
  belongs_to :company
  has_many :results
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :offered_questions

  before_save :reset_counter, :set_next_delivery,
    unless: :skip_callback?

  before_save :calculate_number_of_repeats,
    if: Proc.new { |survey| survey.finish_on.present? },
    unless: :skip_callback?

  after_save :add_schedule, unless: :skip_callback?
  after_destroy :delete_schedule

  attr_accessor :skip_callback

  def skip_callback?
    skip_callback
  end

  def start_in_future?
    if start_at.present? &&
        start_at <= DateTime.now + 2.minutes
      errors.add(:start_at, "can't be in the past or right now")
    end
  end

  def finish_after_start?
    if finish_on.present? && finish_on <= start_at
      errors.add(:finish_on, "can't be before start")
    end
  end

  def reset_counter
    self.counter = 0
  end

  def set_next_delivery
    self.next_delivery_at = start_at
  end

  def calculate_number_of_repeats
    calculation = RepeatsCalculator.new(self)
    self.number_of_repeats = calculation.result
  end

  def add_schedule
    schedule = SchedulesConfigurator.new(self)
    schedule.add_to_scheduler
  end

  def delete_schedule
    Resque.remove_schedule("send_emails_for_survey_#{id}")
  end

  def completed?
    number_of_repeats == counter
  end

  def daily?
    repeat_mode == 'd'
  end

  def weekly?
    repeat_mode == 'w'
  end

  def get_statistics
    StatisticsService.new(self)
  end
end
