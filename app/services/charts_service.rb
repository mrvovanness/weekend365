class ChartsService
  def initialize(survey)
    @survey = survey
  end

  def number_of_responses(filtered_answers=@survey.answers)
    filtered_answers.where(result: @survey.results)
      .group_by_day('answers.created_at').count
  end

  def average_by_company(filtered_answers=@survey.answers, period='d')
    answers = OfferedAnswer.joins(:answers)
      .where(answers: { id: filtered_answers })
    answers = group_by_period(answers, period)
    company_hash = answers.average(:value)

    round_hash_values(company_hash)
  end

  def average_by_country(period='d', date_filter='')
    answers = OfferedAnswer.joins(:answers)
      .where(answers: { result: get_results_of_one_country(date_filter) })
    answers = group_by_period(answers, period)
    country_hash = answers.average(:value)

    round_hash_values(country_hash)
  end

  def average_by_industry(period='d', date_filter='')
    answers = OfferedAnswer.joins(:answers)
      .where(answers: { result: get_results_of_one_industry(date_filter) })
    answers = group_by_period(answers, period)
    industry_hash = answers.average(:value)
    
    round_hash_values(industry_hash)
  end

  def distribution(filtered_answers=@survey.answers)
    OfferedAnswer.joins(:answers)
      .where(answers: { id: filtered_answers } )
      .group(:value).count
  end

  def get_results_of_one_industry(date_filter)
    StatisticsService.new(@survey).all_results_of_one_industry(date_filter)
  end

  def get_results_of_one_country(date_filter)
    StatisticsService.new(@survey).all_results_of_one_country(date_filter)
  end

  private

  def group_by_period(answers, period)
    case period
    when 'm'
      answers.group_by_month('answers.created_at', format: "%b %Y")
    when 'w'
      answers.group_by_week('answers.created_at', format: "%b %d, %Y")
    else
      answers.group_by_day('answers.created_at', format: "%b %d, %Y")
    end
  end

  def round_hash_values(hash)
    hash.each do |key, value|
      hash[key] = value.to_f.round(1)
    end
  end
end
