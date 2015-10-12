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

  # Set 'first_at' after every job (for sustainability on deploy)
  def calculate_next_delivery
    interval = @survey.repeat_every
    next_delivery_date =
      case
      when @survey.counter == 0 || @survey.time.present?
        set_next_delivery
      when @survey.repeat_mode == 'd'
        @survey.next_delivery_at + interval.days
      when @survey.repeat_mode == 'w'
        @survey.next_delivery_at + interval.weeks
      end

    @survey.update_column(:next_delivery_at, next_delivery_date)
    next_delivery_date
  end

  def set_next_delivery
    if @survey.started?
      date = @survey.next_delivery_at
      time = Time.parse(@survey.time)
      @survey.next_delivery_at =
        Time.zone.local(date.year, date.month, date.day,
                        time.hour, time.min, time.sec)
    else
      @survey.next_delivery_at = @survey.start_at
    end

    @survey.next_delivery_at
  end
end
