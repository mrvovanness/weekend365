class SchedulesConfigurator
  def initialize(survey)
    @survey = survey
  end

  # Set dynamic schedule on create/update
  def add_to_scheduler
    name = "send_emails_for_survey_#{@survey.id}"
    config = {}
    if @survey.counter == 0
      config[:every] = ["#{@survey.repeat_every}#{@survey.repeat_mode}",
                       { first_at: @survey.start_at }]
    else
      config[:every] = calculate_new_every
    end
    config[:class] = 'SendEmailsJob'
    config[:queue] = 'send_emails'
    config[:persist] = true
    config[:args] = @survey.id
    Resque.set_schedule(name, config)
  end

  # set 'first_at' after every job (for sustainability on deploy)
  def calculate_new_every
    every_expression = "#{@survey.repeat_every}#{@survey.repeat_mode}"
    [ every_expression, { first_at: calculate_next_delivery }]
  end

  def calculate_next_delivery 
    mode = @survey.repeat_mode == 'w' ? 'weeks' : 'days'
    chronic_expression = "in #{@survey.repeat_every} #{mode}"
    new_delivery_date = Chronic.parse(chronic_expression,
                                 now: @survey.next_delivery_at)
    @survey.update_column(:next_delivery_at, new_delivery_date)
    new_delivery_date
  end
end
