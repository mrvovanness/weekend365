class CompanySurvey < ActiveRecord::Base
  ##validates :title, :start_on, :time, :message, presence: true

  ##validates :repeat_every, numericality: {
  #  only_integer: true, greater_than: 0, less_than: 366 }
  ##validates :number_of_repeats, numericality: {
  #  only_integer: true, greater_than: 1, less_than: 1001 }

  ##validate :start_in_future?, :finish_after_start?,
  #  unless: :skip_callback?

  before_save :reset_counter, :join_date_time, :set_next_delivery,
    unless: :started?

  #after_save :add_schedule, unless: :skip_callback?
  #after_destroy :delete_schedule

  attr_accessor :skip_callback
  attr_writer :time, :start_on

  belongs_to :company
  has_many :results
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :offered_questions

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
    if finish_on && start_at && finish_on <= start_at
      errors.add(:finish_on, "can't be before start")
    end
  end

  def reset_counter
    self.counter = 0
  end

  def join_date_time
    date = Date.parse(self.start_on)
    time = Time.new(self.time)
    self.start_at = DateTime.new(date.year, date.month, date.day,
                                 time.hour, time.min, time.sec)
  end

  def set_next_delivery
    self.next_delivery_at = start_at
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

  def started?
    counter > 0
  end

  def get_statistics
    StatisticsService.new(self)
  end

  def get_charts
    ChartsService.new(self)
  end
end
