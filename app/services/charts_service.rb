class ChartsService
  include SharedMethods

  def initialize(survey)
    @survey = survey
  end

  def number_of_responses(filtered_answers=@survey.answers)
    filtered_answers.where(result: @survey.results)
      .group_by_day('answers.created_at').count
  end

  def average_by_company(filtered_answers=@survey.answers, period='day')
    #old_locale = I18n.locale
    #I18n.locale = :en
    group_options = {
      permit: %w[day week month],
      format: chart_format(period),
      locale: I18n.locale
    }
    company_hash = OfferedAnswer.joins(:answers)
      .where(answers: { id: filtered_answers })
      .group_by_period(period, 'answers.created_at', group_options)
      .average(:value)
    #I18n.locale = old_locale

    round_hash_values(company_hash)
  end

  def average_by_country(period='day', date_filter='')
    group_options = {
      permit: %w[day week month],
      format: chart_format(period),
      locale: I18n.locale
    }
    country_hash = OfferedAnswer.joins(:answers)
      .where(answers: { result: get_results_of_one_country(date_filter) })
      .group_by_period(period, 'answers.created_at', group_options)
      .average(:value)

    round_hash_values(country_hash)
  end

  def average_by_industry(period='day', date_filter='')
    group_options = {
      permit: %w[day week month],
      format: chart_format(period),
      locale: I18n.locale
    }
    industry_hash = OfferedAnswer.joins(:answers)
      .where(answers: { result: get_results_of_one_industry(date_filter) })
      .group_by_period(period, 'answers.created_at', group_options)
      .average(:value)

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

  def correlation
    coordinates = []
    answers = all_answers_by_question

    base_question =
      OfferedQuestion.find_by(
        base_for_correlation: true
      ).try(:id)

    base_question_answers =
      answers.select { |q| q[:id] == base_question }.first[:answers]

    answers.each do |qa_hash| # question-answers hash
      coordinates << { x: find_correlation(qa_hash[:answers],
                                           base_question_answers),
                       y: find_average_of_answers(qa_hash[:answers]),
                       id: qa_hash[:id],
                       base: qa_hash[:base],
                       name: qa_hash[:title] }
    end
    coordinates
  end

  private

  def round_hash_values(hash)
    hash.each do |key, value|
      hash[key] = value.to_f.round(1)
    end
  end

  def chart_format(period)
    case period
    when 'month'
      "%b %Y"
    when 'week'
      "%b %d, %Y"
    else
      I18n.t("date.formats.default")
    end
  end
end
