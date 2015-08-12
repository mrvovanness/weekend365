class SendEmailsJob
  @queue = :send_emails

  def self.perform(survey_id)
    survey = Survey.find(survey_id)
    survey.employees.find_each do |employee|
      SurveysMailer.send_survey(survey, employee.email).deliver_now
      puts "mail to #{employee.name} was delivered"
    end

    survey.update_attribute(:counter, survey.counter += 1)
    if survey.counter == survey.number_of_repeats
      Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
    end
    puts "send number #{survey.counter} from #{survey.number_of_repeats}"
  end
end
