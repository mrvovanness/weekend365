class ChartsService
  def initialize(survey)
    @survey = survey
  end

  def number_of_responses
    Answer.where(result: @survey.results)
      .group_by_day(:created_at).count
  end

  def average
    OfferedAnswer.joins(:answers)
      .where(answers: { result: @survey.results })
      .group_by_day('answers.created_at')
      .average(:value)
  end

  def average_by_country
    country_hash =
      OfferedAnswer.joins(:answers)
        .where(answers: { result: get_results_of_one_country })
        .group_by_day('answers.created_at')
        .average(:value)

    round_hash_values(country_hash)
  end

  def average_by_industry
    industry_hash =
      OfferedAnswer.joins(:answers)
        .where(answers: { result: get_results_of_one_industry })
        .group_by_day('answers.created_at')
        .average(:value)

    round_hash_values(industry_hash)
  end

  def distribution
    OfferedAnswer.joins(:answers)
      .where(answers: { result: @survey.results })
      .group(:value).count
  end

  def get_results_of_one_industry
    StatisticsService.new(@survey).all_results_of_one_industry
  end

  def get_results_of_one_country
    StatisticsService.new(@survey).all_results_of_one_country
  end

  private

  def round_hash_values(hash)
    hash.each do |key, value|
      hash[key] = value.to_f.round(1)
    end
  end
end