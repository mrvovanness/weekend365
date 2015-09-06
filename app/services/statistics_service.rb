class StatisticsService
  def initialize(survey)
    @survey = survey
  end

  def average
    OfferedAnswer.joins(:answers)
      .where(answers: { result: @survey.results })
      .average('value').to_f.round(1)
  end

  def count
    OfferedAnswer.joins(:answers)
      .where(answers: { result: @survey.results }).count
  end

  def average_by_country
    OfferedAnswer.joins(:answers)
      .where(answers: { result: all_results_of_one_country })
      .average('value').to_f.round(1)
  end

  def all_results_of_one_country
    Result.joins(:company_survey).where(
      offered_question_id: @survey.offered_questions,
      company_surveys: { company_id: all_companies_of_one_country }
    )
  end

  def all_companies_of_one_country
    Company.where(country: @survey.company.country)
  end

  def average_by_industry
    OfferedAnswer.joins(:answers)
      .where(answers: { result: all_results_of_one_industry })
      .average('value').to_f.round(1)
  end

  def all_results_of_one_industry
    Result.joins(:company_survey).where(
      offered_question_id: @survey.offered_questions,
      company_surveys: { company_id: all_companies_of_one_industry }
    )
  end

  def all_companies_of_one_industry
    Company.where(company_field: @survey.company.company_field)
  end
end
