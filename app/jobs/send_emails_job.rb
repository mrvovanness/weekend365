class SendEmailsJob
  @queue = :send_emails

  def self.perform(survey_id)
    survey = CompanySurvey.includes(:offered_questions).find(survey_id)
    survey.skip_callback = true

    # Count number of email devlveries
    survey.increment!(:counter)

    # Shift next delivery or remove schedule
    if survey.counter > survey.number_of_repeats
      Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
    else
      updated_schedule = SchedulesConfigurator.new(survey)
      updated_schedule.add_to_scheduler
    end

    # mark all existing tokens as expired
    survey.tokens.valid.find_each do |token|
      token.update(expired: true)
    end

    # reset participation rate counters
    survey.update(number_of_responses: 0, emails_counter: 0)

    # Send emails
    survey.employees.find_each do |employee|
      SurveysMailer.send_survey(survey, employee).deliver_now
      survey.increment!(:emails_counter)
    end
  end
end
