class SendEmailsJob
  @queue = :send_emails

  def self.perform(survey_id)
    survey = CompanySurvey.includes(:offered_questions).find(survey_id)

    # Count number of email dellveries
    survey.increment!(:counter)

    # Shift next delivery or remove schedule
    if survey.counter > survey.number_of_repeats || survey.unrepeatable?
      Resque.remove_schedule("for_survey_#{survey.id}")
    else
      timezone = ActiveSupport::TimeZone[survey.company.timezone]
      Time.use_zone(timezone) do
        updated_schedule = SchedulesConfigurator.new(survey.email_schedule)
        updated_schedule.add_to_scheduler
      end
    end

    # mark all existing tokens as expired
    survey.tokens.valid.find_each do |token|
      token.update(expired: true)
    end

    # reset participation rate counters
    survey.update_columns(number_of_responses: 0, emails_counter: 0)

    if survey.answered_by_web_form?
      survey.employees.find_each do |employee|
        SurveysMailer.send_web_survey(survey, employee).deliver_now
        survey.increment!(:emails_counter)
      end
    else
      survey.employees.find_each do |employee|
        SurveysMailer.send_email_survey(survey, employee).deliver_now
        survey.increment!(:emails_counter)
      end
    end
  end
end
