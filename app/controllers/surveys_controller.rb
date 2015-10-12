class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = @company.company_surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true).decorate
  end

  def new
    if @company.employees.empty?
      flash[:info] = t('flash.employees_list')
      redirect_to company_path @company
    end
  end
end

