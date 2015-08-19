class Survey < ActiveRecord::Base
  validates :title, :start_at, :message, presence: true
  validate :start_in_future?, :finish_after_start?
  belongs_to :company
  has_and_belongs_to_many :employees
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions
  has_many :scaled_questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  before_save :reset_counter, :set_next_delivery
  after_save :add_schedule
  after_destroy :delete_schedule

  def start_in_future?
    if start_at.present? &&
        start_at <= DateTime.now + 2.minutes
      errors.add(:start_at, "can't be in the past or within 3 minutes from now")
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
end
