class SurveysController < ApplicationController
  before_action :authenticate_user!, :set_company
  before_action :set_survey, except: [:index, :new, :create]
  respond_to :json, only: :update_employees

  def index
    @search = @company.surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true)
  end

  def new
    @survey = @company.surveys.build
    @survey.questions.build
  end

  def edit
  end

  def create
    @survey = @company.surveys.create(survey_params)
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
    params.require(:survey).permit(
      :title, :start_on, :start_at, :finish_on, :time_zone,
      :number_of_repeats, :repeat_every,
      :repeat_mode, :message, :skip_callback,
      :employee_ids => [], questions_attributes: [:id, :title, :type])
  end

  def set_company
    @company = current_user.company
  end

  def set_survey
    @survey = @company.surveys.find(params[:id])
  end
end
