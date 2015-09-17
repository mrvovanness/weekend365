class Surveys::PulsesController < ApplicationController
  before_action :authenticate_user!, :set_company
  before_action :set_survey, except: [:index, :new, :create]
  respond_to :json, only: :update_employees

  def index
    @search = @company.company_surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true).decorate
  end

  def new
    load_offered_survey
    @survey = @company.company_surveys.build
  end

  def edit
    load_offered_survey
  end

  def create
    @survey = @company.company_surveys.create(survey_params)
    load_offered_survey if @survey.errors.present?
    respond_with @survey,
      location: -> { preview_surveys_pulse_path(@survey) }
  end

  def update
    @survey.update(survey_params)
    load_offered_survey if @survey.errors.present?
    respond_with @survey,
      location: -> { preview_surveys_pulse_path(@survey) }
  end

  def destroy
    @survey.destroy
    respond_with @survey, location: -> { surveys_path }
  end

  def preview
  end

  def update_employees
    @survey.update_attributes(survey_params)
    respond_with @survey.employees.count
  end

  private

  def survey_params
    params.require(:company_survey).permit(
      :title, :start_at, :finish_on,
      :number_of_repeats, :repeat_every,
      :repeat_mode, :message, :skip_callback,
      :employee_ids => [], :offered_question_ids => [])
  end

  def set_company
    @company = current_user.company
  end

  def set_survey
    @survey = @company.company_surveys.find(params[:id])
  end

  def load_offered_survey
    @offered_survey = PulseSurvey.first
    @offered_questions = @offered_survey.offered_questions
      .includes(:offered_answers).uniq
  end
end
