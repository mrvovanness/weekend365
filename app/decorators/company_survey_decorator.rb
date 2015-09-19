class CompanySurveyDecorator < Draper::Decorator
  delegate_all

  def header
    I18n.t('decorators.company_survey.header', id: id, title: title)
  end

  def status
    if counter == number_of_repeats
      I18n.t('decorators.company_survey.completed_status',
             counter: counter)
    else
      I18n.t('decorators.company_survey.uncompleted_status',
             counter: counter)
    end
  end

  def schedule_overview
    period = if weekly?
               I18n.t('decorators.company_survey.week')
             else
               I18n.t('decorators.company_survey.day')
             end
    I18n.t('decorators.company_survey.schedule', repeat_every: repeat_every,
      repeat_period: period, start_at: start_at.strftime('%I:%M%P'),
      start_from: start_at.strftime('%b %dth %Y'))
  end

  def frequency_overview
    if daily?
      I18n.t('decorators.company_survey.daily_frequency',
        repeat_every: repeat_every, start_at: start_at.strftime('%I:%M%P'))
    elsif weekly?
      I18n.t('decorators.company_survey.weekly_frequency',
        repeat_every: repeat_every, weekday: start_at.strftime('%A'),
        daytime: start_at.strftime('%I:%M%P'))
    end
  end

  def repeat_times
    [I18n.t('surveys.preview.repeat'),
     number_of_repeats,
     I18n.t('surveys.preview.times')
    ].join(' ')
  end
end