class SendEmailsJob
  @queue = :send_emails

  def self.perform(survey_id)
    survey = Survey.includes(:questions).find(survey_id)
    survey.employees.find_each do |employee|
      SurveysMailer.send_survey(survey, employee.email).deliver_now
    end

    survey.update_column(:counter, survey.counter += 1)

    if survey.counter == survey.number_of_repeats
      Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
    else
      updated_schedule = SchedulesConfigurator.new(survey)
      updated_schedule.add_to_scheduler
    end
  end
end
