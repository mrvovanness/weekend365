class EmployeesController < ApplicationController

  before_action :authenticate_user!, :set_company

  def new
    @employee = @company.employees.build
  end

  def edit
    @employee = @company.employees.find(params[:id])
  end

  def create
    @employee = @company.employees.create(employee_params)
    respond_with @employee, location: -> { root_path }
  end

  def update
    @employee = @company.employees.find(params[:id])
    @employee.update(employee_params)
    respond_with @employee, location: -> { root_path }
  end

  def add_to_survey
    @employees = @company.employees.where(id: params[:employee_ids])
    @employees.update_all(selected_to_survey: true)
    respond_with @employee, location: -> { root_path }
  end

  private

  def set_company
    @company = current_user.company
  end

  def employee_params
    params.require(:employee).permit(:name, :department, :position, :email)
  end
end
