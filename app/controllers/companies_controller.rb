class CompaniesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :set_company
  before_action :define_company, except: [:index, :new, :create]
  before_action :check_access, only: [:index, :destroy]
  before_action :reset_company, only: [:index]
  before_action :define_admin, only: [:show, :edit]

  def index
    @companies = Company.order(:name).page(params[:page]).per(15)
  end

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
    @company.change_admin(params[:admin].to_i) if params[:admin]
    define_admin
    @company.update(company_params)
    respond_with @company, location: -> { company_path(@company) }
  end

  def destroy
    @company.destroy
    respond_with @company, location: -> { companies_path }
  end

  private

  def check_access
    redirect_to dashboard_index_path and return unless current_user.is_admin?
  end

  def reset_company
    session[:current_company] = nil
  end

  def define_company
    if current_user.is_admin? && params[:id]
      @company = Company.find(params[:id])
      session[:current_company] = @company.id
    else
      @company = current_user.company
    end
  end

  def define_admin
    @company_admin = @company.admin
  end

  def company_params
    params.require(:company).permit(
      :name, :company_field_id, :office_address,
      :country, :timezone, :description, :website,
      :employees_number, :employees_registered, :subscribed)
  end
end
