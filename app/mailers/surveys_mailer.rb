class SurveysMailer < ActionMailer::Base

  def send_email_survey(survey, employee)
    @survey = survey
    I18n.locale = (@survey.locale || 'en').to_sym
    token = survey.tokens.create(name: SecureRandom.hex(10), expired: false)
    @answers = @survey.offered_questions.first.offered_answers
    @employee = employee
    @token = token.name
    @company_admin = @survey.company.admin
    mail(to: @employee.email, subject: @survey.title)
  end

  def send_web_survey(survey, employee)
    @survey = survey
    I18n.locale = (@survey.locale || 'en').to_sym
    token = survey.tokens.create(name: SecureRandom.hex(10), expired: false)
    @employee = employee
    @token = token.name
    @company_admin = @survey.company.admin
    mail(to: @employee.email, subject: @survey.title)
  end
end
