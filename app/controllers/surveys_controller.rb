class SurveysController < ApplicationController
  before_action :authenticate_user!, :set_company
  before_action :set_survey, except: [:index, :new, :create]
  respond_to :json, only: :update_employees

  def index
    @search = @company.company_surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true)
  end

  def new
    @offered_survey = OfferedSurvey.find_by(type: offered_survey_query)
    @offered_questions = @offered_survey.offered_questions
      .includes(:offered_answers).uniq
    @survey = @company.company_surveys.build(offered_questions: @offered_questions)
  end

  def edit
  end

  def create
    @survey = @company.company_surveys.create(survey_params)
    respond_with @survey, location: -> { preview_survey_path(@survey) }
  end

  def update
    @survey.update(survey_params)
    respond_with @survey, location: -> { preview_survey_path(@survey) }
  end

  def destroy
    @survey.destroy
    respond_with @survey
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
      :employee_ids => [], :offered_questions => [])
  end

  def offered_survey_query
    query = params[:survey_type]
    if query == 'PulseSurvey'
      query
    else
      redirect_to surveys_path and return
    end
  end

  def set_company
    @company = current_user.company
  end

  def set_survey
    @survey = @company.company_surveys.find(params[:id])
  end
end
