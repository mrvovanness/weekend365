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
      survey.repeat_mode == 'w' ? mode = 'weeks' : mode = 'days'
      next_date = Chronic.parse("in #{survey.repeat_every} #{mode}")
      name = "send_emails_for_survey_#{survey.id}"
      config = {}
      config[:every] = ["#{survey.repeat_every}#{survey.repeat_mode}",
                        {next_time: next_date.in_time_zone('UTC')}]
      config[:class] = 'SendEmailsJob'
      config[:queue] = 'send_emails'
      config[:persist] = true
      config[:args] = survey.id
      Resque.set_schedule(name, config)
    end
  end
end
