class SurveysMailer < ActionMailer::Base

  def send_survey(survey, email)
    @token = Token.create(name: SecureRandom.hex(10), expired: false)
    @survey = survey
    mail(to: email, subject: @survey.title)
  end
end
