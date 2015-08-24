class SurveysController < ApplicationController
  before_action :set_company, :authenticate_user!

  def index
    @search = @company.surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true)
  end

  def new
    @survey = @company.surveys.build
    @survey.questions.build
  end

  def edit
    @survey = @company.surveys.find(params[:id])
  end

  def create
    @survey = @company.surveys.create(survey_params)
    respond_with @survey
  end

  def update
    @survey = @company.surveys.find(params[:id])
    @survey.update(survey_params)
    respond_with @survey
  end

  def destroy
    @survey = @company.surveys.find(params[:id])
    @survey.destroy
    respond_with @survey
  end

  private

  def survey_params
    params.require(:survey).permit(
      :title, :start_on, :start_at, :finish_on, :time_zone,
      :number_of_repeats, :repeat_every, :repeat_mode, :message,
      :employee_ids => [], questions_attributes: [:id, :title, :type])
  end

  def set_company
    @company = current_user.company
  end

end
