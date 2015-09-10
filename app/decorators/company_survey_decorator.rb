class CompanySurveyDecorator < Draper::Decorator
  delegate_all

  def header
    "SURVEY ##{id}: #{title}"
  end

  def schedule_overview
    "Every #{repeat_every}
    #{weekly? ? 'week' : 'day' }
    at #{start_at.strftime('%I:%M%P')}
    from #{start_at.strftime('%b %dth %Y')}"
  end

  def frequency_overview
    if daily?
      "every #{repeat_every} day(s)"\
      "#{survey.start_at.strftime('at %I:%M%P')}"
    elsif weekly?
      "every #{repeat_every} week(s)"\
      "on #{start_at.strftime('%A')}"\
      "#{start_at.strftime(' at %I:%M%P')}"
    end
