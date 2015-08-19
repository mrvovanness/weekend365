class RepeatsCalculator

  def initialize(survey)
    @survey = survey
  end

  def result
    calculate_repeats == 0 ? 1 : calculate_repeats
  end

  def calculate_repeats
    case
    when @survey.repeat_mode == 'w'
      difference_in_days/(7 * @survey.repeat_every)
    when @survey.repeat_mode == 'd'
      difference_in_days/@survey.repeat_every
    end
  end

  def difference_in_days
    (@survey.finish_on - @survey.start_at.to_date).to_i
  end
end
