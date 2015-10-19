def get_redis_data(survey_id)
  Resque.reload_schedule!["for_survey_#{survey_id}"]
end

def persisted_in_redis?(survey_id)
  Resque.schedule_persisted?("for_survey_#{survey_id}")
end
