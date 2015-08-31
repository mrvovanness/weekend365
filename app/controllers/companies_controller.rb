class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: [:new, :create]

  def show
    @search = @company.employees.ransack(params[:q])
    @employees = @search.result(distinct: true).page(params[:page]).per(15)

    respond_to do |format|
      format.html
      format.csv { send_data @search.result.to_csv,
        filename: "employees-#{ Date.today }.csv" }
    end
  end

  def new
    redirect_to :back and return if current_user.company.present?
    @company = current_user.build_company
    render layout: 'home'
  end

  def edit
    @search = @company.employees.ransack(params[:q])
  end

  def create
    @company = current_user.create_company(company_params)
    if @company.save
      respond_with @company,
        location: -> { company_path(@company) }
    else
      render :new, layout: 'home'
    end
  end

  def update
    @company.update(company_params)
    respond_with @company, location: -> { company_path(@company) }
  end

  private

  def set_company
    @company = current_user.company
  end

  def company_params
    params.require(:company).permit(
      :name, :company_field_id, :office_address,
      :country, :description, :website,
      :employees_number, :employees_registered)
  end
end
