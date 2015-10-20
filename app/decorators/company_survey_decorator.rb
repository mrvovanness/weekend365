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
      repeat_period: period, start_at: start_at.try(:strftime, '%I:%M%P'),
      start_from: start_at.strftime('%b %dth %Y'))
  end

  def frequency_overview
    if daily?
      I18n.t('decorators.company_survey.daily_frequency',
        repeat_every: repeat_every, start_at: start_at.try(:strftime, '%I:%M%P'))
    elsif weekly?
      I18n.t('decorators.company_survey.weekly_frequency',
        repeat_every: repeat_every, weekday: start_at.try(:strftime, '%A'),
        daytime: start_at.try(:strftime, '%I:%M%P'))
    end
  end

  def repeat_times
    [I18n.t('surveys.preview.repeat'),
      number_of_repeats,
      I18n.t('surveys.preview.times')
    ].join(' ')
  end

  def set_title(offered_survey, company)
    if title.present?
      title
    else
      I18n.t('simple_form.placeholders.company_survey.title',
        survey_title: offered_survey.title,
        company_name: company.name)
    end
  end

  def set_time
    if errors.present?
      email_schedule.time
    elsif start_at.present?
      start_at.try(:strftime, '%H:%M')
    else
      (Time.current. + 30.minutes).try(:strftime, '%H:%M')
    end
  end

  def set_start_on
    if errors.present?
      email_schedule.start_on
    elsif email_schedule.start_at.present?
      email_schedule.start_at.try(:strftime, '%Y-%m-%d')
    else
      date = Date.current
      date.try(:strftime, '%Y-%m-%d')
    end
  end

  def set_finish_on
    if finish_on.present?
      finish_on.try(:strftime, '%Y-%m-%d')
    else
      date = Date.today + 3.months
      date.try(:strftime, '%Y-%m-%d')
    end
  end

  def set_hint_for_start_on
    if started?
      I18n.t('simple_form.hints.company_survey.start_on_opt')
    end
  end
end
