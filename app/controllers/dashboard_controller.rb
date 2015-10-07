class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @surveys = @company.company_surveys.order(start_at: :desc).decorate
    @top_survey = @surveys.first
  end

  def show
    @survey = @company.company_surveys.find(params[:id]).decorate
    @search = @survey.employees.ransack(params[:q])
    @answers = Answer.filter_by_employees(@search.result)
  end
end
