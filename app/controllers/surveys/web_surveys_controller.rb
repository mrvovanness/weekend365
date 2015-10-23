module Surveys
  class WebSurveysController < ApplicationController
    before_action :authenticate_user!
    before_action :set_company_survey, except: [:new, :create]

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

    def edit
      load_offered_survey
      load_not_included_questions
    end

    def update
      @company_survey.update(company_survey_params)
      if @company_survey.errors.present?
        load_offered_survey
        load_not_included_questions
      end
      respond_with @company_survey, location: -> { surveys_path }
    end


    private

    def company_survey_params
      params.require(:company_survey)
        .permit(:title,
                :repeat,
                :offered_survey_id,
                offered_question_ids: [])
    end

    def set_company_survey
      @company_survey = @company.company_surveys.find(params[:id]).decorate
    end

    def load_offered_survey
      @offered_survey = OfferedSurvey.includes(
        offered_questions: [:translations, :offered_answers]
      ).find(params[:offered_survey_id])
    end

    def load_not_included_questions
      all_questions = @offered_survey.ordered_by_topic_questions.to_a
      included_questions = @company_survey.ordered_by_topic_questions.to_a
      @not_included_questions = all_questions - included_questions
    end
  end
end
