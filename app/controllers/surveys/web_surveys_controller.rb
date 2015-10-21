module Surveys
  class WebSurveysController < ApplicationController
    before_action :authenticate_user!

    def new
      @company_survey = @company.company_surveys.build.decorate
      load_offered_survey
    end

    def create
      @company_survey = @company.company_surveys
        .create(company_survey_params).decorate
      load_offered_survey if @company_survey.errors.present?
      respond_with @company_survey, location: -> { surveys_path }
    end

    private

    def company_survey_params
      params.require(:company_survey)
        .permit(:title,
                :repeat,
                offered_question_ids: [])
    end

    def load_offered_survey
      @offered_survey = OfferedSurvey.includes(
        offered_questions: [:translations, :offered_answers]
      ).find(params[:offered_survey_id])
    end
  end
end
