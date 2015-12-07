class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_department
  before_action :set_employee, only: [:edit, :update, :destroy]
  respond_to :json, only: :index

  def index
    @search = @department.employees.ransack(params[:q])
    @employees = @search.result.order(:name)
    respond_with @employees
  end

  def new
    @employee = @department.employees.build
    @employee.build_office_location
  end

  def edit
  end

  def create
    @employee = @department.employees.create(employee_params)
    redirect_to_department
  end

  def update
    @employee.update(employee_params)
    redirect_to_department
  end

  def destroy
    @employee.destroy
    redirect_to_department
  end

  def destroy_selected
    Employee.destroy(params[:employee_ids])
    redirect_to_department
  end

  def add_to_survey
    survey = @company.company_surveys.find(params[:survey_id])
    survey.employee_ids = (survey.employee_ids + params[:employee_ids]).uniq
    survey.save
    redirect_to_department
  end

  def import
    if @company.employees.import(params[:file], @company)
      flash[:info] = "Employees were successfully imported"
      redirect_to company_path(@company)
    else
      flash[:info] = "Something went wrong, check your csv file"
      @employee = @company.employees.build
      render :new
    end
  end

  private

  def redirect_to_company
    respond_with @employee, location: -> { company_path(@company) }
  end

  def redirect_to_department
    respond_with @employee, location: -> { company_department_path(@company, @department) }
  end

  def set_employee
    @employee = @company.employees.includes(:department).find(params[:id])
  end

  def set_department
    if user_signed_in?
      @department = Department.find(params[:department_id])
    end
  end

  def employee_params
    params.require(:employee).permit(
      :first_name, :last_name, :department, :department_code, :position,
      :email, :gender, :joining_date, :ethnicity, :birthday, :country, :department_id)
  end
end
