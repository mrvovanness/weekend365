class Survey < ActiveRecord::Base
  validates :title, :start_on, :start_at, :message, presence: true
  validate :start_in_future?, :finish_after_start?
  belongs_to :company
  has_and_belongs_to_many :employees
  has_many :questions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

  before_save :reset_counter
  after_save :schedule_send_emails
  after_destroy :delete_schedule

  def start_in_future?
    if start_at.present? &&
        start_on.present? &&
        join_date_time(self) <= DateTime.now + 3.minutes
      errors.add(:start_on, "can't be in the past")
      errors.add(:start_at, "can't be in the past or within 3 minutes from now")
    end
  end

  def finish_after_start?
    if finish_on.present? && finish_on <= join_date_time(self)
      errors.add(:finish_on, "can't be before start")
    end
  end

  def reset_counter
    self.counter = 0
  end

  def schedule_send_emails
    start_date = join_date_time(self)
    name = "send_emails_for_survey_#{id}"
    config = {}
    config[:every] = ["#{repeat_every}#{repeat_mode}",
                     {first_at: start_date, times: number_of_repeats}]
    config[:class] = 'SendEmailsJob'
    config[:queue] = 'send_emails'
    config[:persist] = true
    config[:args] = id
    Resque.set_schedule(name, config)
  end

  def join_date_time(survey)
    (survey.start_on.to_s + ' ' + survey.start_at.to_s).to_datetime
  end

  def delete_schedule
    Resque.remove_schedule("send_emails_for_survey_#{id}")
  end

end
