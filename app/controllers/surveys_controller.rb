class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = @company.company_surveys
      .includes(:email_schedule).ransack(params[:q])
    @surveys = @search.result.decorate
  end

  def new
    if @company.employees.empty?
      flash[:info] = t('flash.employees_list')
      redirect_to company_path @company
    else
      @offered_surveys = OfferedSurvey.includes(:translations).order(created_at: :asc)
      @email_survey = @offered_surveys.first
    end
  end
end

