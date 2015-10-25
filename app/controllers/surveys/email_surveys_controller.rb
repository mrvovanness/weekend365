class Surveys::EmailSurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, except: [:index, :new, :create]

  def index
    @search = @company.company_surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true).decorate
  end

  def new
    load_offered_survey
    @survey = @company.company_surveys.build.decorate
    @survey.email_schedule = EmailSchedule.new
  end

  def edit
    load_offered_survey
  end

  def create
    @survey = @company.company_surveys.create(survey_params).decorate
    load_offered_survey if @survey.errors.present?
    respond_with @survey,
      location: -> { preview_surveys_email_survey_path(@survey) }
  end

  def update
    @survey.update(survey_params)
    load_offered_survey if @survey.errors.present?
    respond_with @survey,
      location: -> { preview_surveys_email_survey_path(@survey) }
  end

  def preview
  end

  private

  def survey_params
    params.require(:company_survey).permit(
      :title,
      :message,
      :locale,
      employee_ids: [],
      offered_question_ids: [],
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

  def set_survey
    @survey = @company.company_surveys.find(params[:id]).decorate
  end

  def load_offered_survey
    @offered_survey = OfferedSurvey.first
    @offered_questions = @offered_survey.offered_questions
      .includes(:offered_answers).uniq
  end
end
