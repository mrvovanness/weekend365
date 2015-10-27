class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @surveys = @company.company_surveys.includes( :offered_survey, :email_schedule)
      .order(updated_at: :desc).decorate
    @top_survey = @surveys.first
    @period = params[:period] || 'd'
  end

  def show
    @survey = @company.company_surveys.find(params[:id]).decorate
    @search = @company.employees.ransack(params[:q])
    @answers = Answer.filter_by_employees(@search.result, @survey)
    @comments = @survey.answers.map(&:comment).compact.last(3)
    @period = params[:period] || @survey.weekly? ? 'w' : 'd'
  end
end
