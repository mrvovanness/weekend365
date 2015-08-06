class SurveysMailer < ActionMailer::Base

  def send_survey(survey, email)
    @survey = survey
    mail(to: email, subject: @survey.title)
  end
end
