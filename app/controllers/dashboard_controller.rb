class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @surveys = current_user.company.company_surveys.includes(:answers)
  end
end
