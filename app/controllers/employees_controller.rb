class EmployeesController < ApplicationController
  before_action :authenticate_user!, :set_company
  respond_to :json, only: :index

  def index
    @search = @company.employees.ransack(params[:q])
    @employees = @search.result(distinct: true).order(:name)
    respond_with @employees
  end

  def new
    @employee = @company.employees.build
  end

  def edit
    @employee = @company.employees.find(params[:id])
  end

  def create
    @employee = @company.employees.create(employee_params)
    redirect_to_company
  end

  def update
    @employee = @company.employees.find(params[:id])
    @employee.update(employee_params)
    redirect_to_company
  end

  def add_to_survey
    survey = CompanySurvey.find(params[:id])
    employees = @company.employees.where(id: params[:employee_ids])
    survey.employees << employees
    redirect_to_company
  end

  def import
    @company.employees.import(params[:file], @company)
    redirect_to_company
  end

  private

  def redirect_to_company
    respond_with @employee, location: -> { company_path(@company) }
  end

  def set_company
    @company = current_user.company
  end

  def employee_params
    params.require(:employee).permit(:name, :department, :position, :email)
  end
end
