class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, except: [:index, :new, :update_employees]
  respond_to :json, only: :update_employees

  def index
    @search = @company.company_surveys
      .includes(:email_schedule, :offered_survey).ransack(params[:q])
    @surveys = @search.result.decorate
  end

  def new
    if @company.employees.empty?
      flash[:info] = t('flash.employees_list')
      redirect_to company_path @company
    else
      @offered_surveys = OfferedSurvey.includes(:translations).order(created_at: :asc)
    end
  end

  def destroy
    @survey.destroy
    respond_with @survey
  end

  def preview
  end

  def update_employees
    @survey = CompanySurvey.find(params[:id])
    @survey.update_attributes!(
      params.require(:company_survey).permit(employee_ids: [])
    )
  end

  private

  def set_survey
    @survey = @company.company_surveys.includes(
      offered_questions: :translations
    ).find(params[:id]).decorate
  end
end

