class EmployeesController < ApplicationController
  before_action :authenticate_user!, :set_company
  before_action :set_employee, only: [:edit, :update, :destroy]
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
  end

  def create
    @employee = @company.employees.create(employee_params)
    redirect_to_company
  end

  def update
    @employee.update(employee_params)
    redirect_to_company
  end

  def destroy
    @employee.destroy
    redirect_to_company
  end

  def destroy_selected
    Employee.destroy(params[:employee_ids])
    redirect_to :back
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

  def set_employee
    @employee = @company.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :name, :department, :position,
      :email, :gender, :birthday, :country)
  end
end
