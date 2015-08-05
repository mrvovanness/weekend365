class SurveysMailer < ActionMailer::Base

  def send_mails(survey_id)
    mail(to: 'ex@mail.com', subject: Survey.find(survey_id).title)
  end
end
