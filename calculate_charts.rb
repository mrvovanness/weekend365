puts Answer.where(result_id: Result.where(company_survey_id: Company.find(110).company_surveys.first)).group_by_day(:created_at).count
Answer.where(result_id: Result.where(company_survey_id: Company.find(110).company_surveys.first)).count
