class SchedulesConfigurator
  def initialize(survey)
    @survey = survey
  end

  # Set dynamic schedule on create/update
  def add_to_scheduler
    name = "send_emails_for_survey_#{@survey.id}"
    config = {}
    config[:every] = ["#{@survey.repeat_every}#{@survey.repeat_mode}",
                     { first_at: calculate_next_delivery }]
    config[:class] = 'SendEmailsJob'
    config[:queue] = 'send_emails'
    config[:persist] = true
    config[:args] = @survey.id
    Resque.set_schedule(name, config)
  end

  # set 'first_at' after every job (for sustainability on deploy)
  def calculate_next_delivery
    interval = @survey.repeat_every
    next_delivery_date =
      case
      when @survey.counter == 0
        @survey.next_delivery_at
      when @survey.repeat_mode == 'd'
        @survey.next_delivery_at + interval.days
      when @survey.repeat_mode == 'w'
        @survey.next_delivery_at + interval.weeks
      end

    @survey.update_column(
      :next_delivery_at, next_delivery_date
      ) unless @survey.new_record?
    next_delivery_date
  end
end
