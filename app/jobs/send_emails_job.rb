class SendEmailsJob
  @queue = :send_emails

  def self.perform(survey_id)
    SurveysMailer.send_mails(survey_id).deliver_now
  end
end
