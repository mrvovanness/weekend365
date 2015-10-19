class SchedulesConfigurator
  def initialize(schedulable)
    @schedulable = schedulable
  end

  # Set dynamic schedule on create/update
  def add_to_scheduler
    name = "for_survey_#{@schedulable.company_survey.id}"
    config = {}
    config[:every] = ["#{@schedulable.repeat_every}#{@schedulable.repeat_mode}",
                     { first_at: calculate_next_delivery }]
    config[:class] = 'SendEmailsJob'
    config[:queue] = 'send_emails'
    config[:persist] = true
    config[:args] = @schedulable.company_survey.id
    Resque.set_schedule(name, config)
  end

  # Set 'first_at' after every job to next delivery
  def calculate_next_delivery
    interval = @schedulable.repeat_every
    next_delivery_date =
      case
      when @schedulable.company_survey.counter == 0 || @schedulable.time.present?
        set_next_delivery
      when @schedulable.repeat_mode == 'd'
        @schedulable.next_delivery_at + interval.days
      when @schedulable.repeat_mode == 'w'
        @schedulable.next_delivery_at + interval.weeks
      end

    @schedulable.update_column(:next_delivery_at, next_delivery_date)
    next_delivery_date
  end

  def set_next_delivery
    if @schedulable.started?
      date = @schedulable.next_delivery_at
      time = Time.parse(@schedulable.time)
      @schedulable.next_delivery_at =
        Time.zone.local(date.year, date.month, date.day,
                        time.hour, time.min, time.sec)
    else
      @schedulable.next_delivery_at = @schedulable.start_at
    end

    @schedulable.next_delivery_at
  end
end
