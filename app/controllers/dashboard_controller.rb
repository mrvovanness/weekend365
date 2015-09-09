class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @surveys = current_user.company.company_surveys
      .order(start_at: :desc)
    @top_survey = @surveys.first
  end

  def show
    @survey = current_user.company.company_surveys.find(params[:id])
  end
end
