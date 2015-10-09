class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = @company.company_surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true).decorate
  end
end

