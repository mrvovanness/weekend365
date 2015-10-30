class ChartsService
  def initialize(survey)
    @survey = survey
  end

  def number_of_responses(filtered_answers=@survey.answers)
    filtered_answers.where(result: @survey.results)
      .group_by_day('answers.created_at').count
  end

  def average_by_company(filtered_answers=@survey.answers, period='d')
    old_locale = I18n.locale
    I18n.locale = :en
    answers = OfferedAnswer.joins(:answers)
      .where(answers: { id: filtered_answers })
    company_hash = average_for_period(answers, period)
    I18n.locale = old_locale

    round_hash_values(company_hash)
  end

  def average_by_country(period='d', date_filter='')
    old_locale = I18n.locale
    I18n.locale = :en
    answers = OfferedAnswer.joins(:answers)
      .where(answers: { result: get_results_of_one_country(date_filter) })
    country_hash = average_for_period(answers, period)
    I18n.locale = old_locale

    round_hash_values(country_hash)
  end

  def average_by_industry(period='d', date_filter='')
    old_locale = I18n.locale
    I18n.locale = :en
    answers = OfferedAnswer.joins(:answers)
      .where(answers: { result: get_results_of_one_industry(date_filter) })
    industry_hash = average_for_period(answers, period)
    I18n.locale = old_locale
    
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

  def average_for_period(answers, period)
    case period
    when 'm'
      answers.group_by_month('answers.created_at', format: "%b %Y").average(:value)
    when 'w'
      answers.group_by_week('answers.created_at', format: "%b %d, %Y").average(:value)
    else
      answers.group_by_day('answers.created_at', format: "%b %d, %Y").average(:value)
    end
  end

  def round_hash_values(hash)
    hash.each do |key, value|
      hash[key] = value.to_f.round(1)
    end
  end
end
