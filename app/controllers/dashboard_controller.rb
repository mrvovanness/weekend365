class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :define_date_filter, only: :show

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
      .ransack(@date_filter).result
    @comments = @survey.answers.map(&:comment).compact.last(3)
    @period = params[:period] || @survey.weekly? ? 'w' : 'd'
  end

  private

  def define_date_filter
    @date_filter = {
      created_at_gteq: Date.today - 1.month,
      created_at_lteq: Date.today
    }
    [:created_at_gteq, :created_at_lteq].each do |key|
      if params[key].present?
        @date_filter[key] = params[key]
      end
    end
  end
end
