class Survey < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :company
  has_and_belongs_to_many :employees
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  after_commit :schedule_send_emails

  def schedule_send_emails
    cronned_date = date_to_cron(self)
    name = "send_emails_for_survey_#{id}"
    config = {}
    config[:class] = 'SendEmailsJob'
    config[:args] = id
    config[:cron] = cronned_date
    config[:persist] = true
    config[:queue] = 'send_emails'
    Resque.set_schedule(name, config)
  end

  def date_to_cron(survey)
    hour = survey.start_at.strftime('%H')
    minute = survey.start_at.strftime('%M')
    day_of_week = survey.start_on.strftime('%w')
    cron = "#{minute} #{hour} * * #{day_of_week}"
    cron
  end
end
