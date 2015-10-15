module Surveys
  class WebSurveysController < ApplicationController
    
    def new
      @company_survey = current_user.company.company_surveys.build.decorate
      @offered_survey = OfferedSurvey.includes(
        offered_questions: [:translations, :offered_answers])
        .find(params[:offered_survey_id])

    end

  end
end
