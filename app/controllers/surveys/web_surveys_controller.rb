module Surveys
  class WebSurveysController < ApplicationController
    before_action :authenticate_user!
    before_action :set_company_survey, except: [:new, :create]

    def new
      @company_survey = @company.company_surveys.build.decorate
      @email_schedule = @company_survey.build_email_schedule
      load_offered_survey
    end

    def create
      # Don't allow create survey untill employees not present
      if @company.employees.empty?
        flash[:info] = t('flash.employees_list')
        redirect_to company_path @company
      else
        @company_survey = @company.company_surveys
          .create(company_survey_params).decorate
        load_offered_survey if @company_survey.errors.present?
        respond_with @company_survey, location: -> { surveys_path }
      end
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

    def preview
    end

    private

    def company_survey_params
      params.require(:company_survey).permit(
        :title,
        :message,
        :repeat,
        :offered_survey_id,
        :locale,
        offered_question_ids: [],
        employee_ids: [],
        email_schedule_attributes: [
          :start_on,
          :id,
          :time,
          :finish_on,
          :number_of_repeats,
          :repeat_every,
          :repeat_mode
        ]
      )
    end

    def set_company_survey
      @company_survey = @company.company_surveys.includes(
        offered_questions: [:offered_answers, :translations]
      ).find(params[:id]).decorate
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
