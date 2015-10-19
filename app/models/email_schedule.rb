class EmailSchedule < ActiveRecord::Base
  belongs_to :company_survey

  validates :start_on, :time, presence: true

  validates :repeat_every, numericality: {
    only_integer: true, greater_than: 0, less_than: 366 }

  validates :number_of_repeats, numericality: {
    only_integer: true, greater_than: 1, less_than: 1001 }

  validate :check_survey_start

  before_validation :write_start_at

  after_save :set_schedule

  after_destroy :delete_schedule

  attr_accessor :start_on, :time

  def write_start_at
    if self.start_on.present? && self.time.present?
      date = Date.parse(self.start_on)
      time = Time.parse(self.time)
      self.start_at = Time.zone.local(date.year, date.month, date.day,
                                      time.hour, time.min, time.sec)
    end
  end

  def set_schedule
    schedule = SchedulesConfigurator.new(self)
    schedule.add_to_scheduler
  end

  def delete_schedule
    Resque.remove_schedule("for_survey_#{company_survey.id}")
  end

  def started?
    if company_survey.present?
      company_survey.counter > 0
    else
      false
    end
  end

  def daily?
    repeat_mode == 'd'
  end

  def weekly?
    repeat_mode == 'w'
  end

  private

  def check_survey_start
   if start_at <= DateTime.current
     errors.add(:start_on, :bad_survey_start) unless started?
    end
  end
end
