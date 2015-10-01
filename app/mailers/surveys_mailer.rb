class SurveysMailer < ActionMailer::Base

  def send_survey(survey, employee)
    token = Token.create(name: SecureRandom.hex(10), expired: false)
    @token = token.name
    @survey = survey
    I18n.locale = @survey.locale.to_sym || :en
    @employee = employee
    mail(to: @employee.email, subject: @survey.title)
  end
end
