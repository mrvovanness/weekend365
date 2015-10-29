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

  def rate
    if @survey.emails_counter > 0
      @survey.number_of_responses.to_f / @survey.emails_counter * 100
    else
      0
    end
  end

  def average_by_country
    OfferedAnswer.joins(:answers)
      .where(answers: { result: all_results_of_one_country })
      .average('value').to_f.round(1)
  end

  def all_results_of_one_country(date_filter='')
    if date_filter.present?
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_country }
        ).ransack(date_filter).result
    else
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_country }
      )
    end
  end

  def all_companies_of_one_country
    Company.where(country: @survey.company.country)
  end

  def average_by_industry
    OfferedAnswer.joins(:answers)
      .where(answers: { result: all_results_of_one_industry })
      .average('value').to_f.round(1)
  end

  def all_results_of_one_industry(date_filter='')
    if date_filter.present?
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_industry }
        ).ransack(date_filter).result
    else
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_industry }
      )
    end
  end

  def all_companies_of_one_industry
    Company.where(company_field: @survey.company.company_field)
  end

  def latest_reply
    begin
      Answer.where(result: @survey.results)
        .order(created_at: :desc).first
        .created_at.try(:strftime, '%b.%dth/%Y at %H:%M')
    rescue
      'none'
    end
  end
end
