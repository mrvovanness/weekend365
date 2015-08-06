class Survey < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :company
  has_and_belongs_to_many :employees
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  after_save :schedule_send_emails

  def schedule_send_emails
    start_date = (start_on.to_s + ' ' + start_at.to_s).to_datetime
    name = "send_emails_for_survey_#{id}"
    config = {}
    config[:class] = 'SendEmailsJob'
    config[:args] = id
    config[:every] = ["#{repeat_every}#{repeat_mode}",
                     {first_at: start_date, times: number_of_repeats}]
    config[:persist] = true
    config[:queue] = 'send_emails'
    Resque.set_schedule(name, config)
  end
end
