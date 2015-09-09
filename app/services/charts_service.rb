class ChartsService
  def initialize(survey)
    @survey = survey
  end

  def number_of_responses
    Answer.where(result_id: Result.where(company_survey_id: @survey)).group_by_day(:created_at).count
  end
end
