class CompanySurvey < ActiveRecord::Base
  validates :title, :start_on, :time, :message, presence: true,
    unless: :skip_callback?

  validates :repeat_every, numericality: {
    only_integer: true, greater_than: 0, less_than: 366 }

  validates :number_of_repeats, numericality: {
    only_integer: true, greater_than: 1, less_than: 1001 }

  validate :check_survey_start, on: :create

  validate :check_survey_start, on: :update,
    unless: :started?

  before_validation :write_start_at,
    unless: :started?

  before_validation :write_start_at,
    unless: :skip_callback?

  after_save :add_schedule,
    unless: :skip_callback?

  after_destroy :delete_schedule

  attr_accessor :skip_callback, :time, :start_on

  belongs_to :company
  has_many :results
  has_many :tokens
  has_many :answers, through: :results
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :offered_questions

  def skip_callback?
    skip_callback
  end

  def write_start_at
    date = Date.parse(self.start_on)
    time = Time.parse(self.time)
    self.start_at = Time.zone.local(date.year, date.month, date.day,
                                    time.hour, time.min, time.sec)
  end

  def add_schedule
    schedule = SchedulesConfigurator.new(self)
    schedule.add_to_scheduler
  end

  def delete_schedule
    Resque.remove_schedule("send_emails_for_survey_#{id}")
  end

  def started?
    counter > 0
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

  def get_charts
    ChartsService.new(self)
  end

  private

  def check_survey_start
    errors.add(:start_on, :bad_survey_start) unless start_at >= DateTime.current
  end
end
