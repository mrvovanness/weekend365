class SendEmailsJob
  @queue = :send_emails

  def self.perform(survey_id)
    survey = Survey.find(survey_id)
    survey.employees.find_each do |employee|
      SurveysMailer.send_survey(survey, employee.email).deliver_now
      puts "mail to #{employee.name} was delivered"
    end
  end
end
