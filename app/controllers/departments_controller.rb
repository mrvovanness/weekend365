class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_department, only: [:edit, :update, :destroy, :show]
  before_action :define_head, only: [:show, :edit]
  respond_to :json, only: :index

  def index
    @search = @company.departments.ransack(params[:q])
    @departments = @search.result.order(:name).page(params[:page]).per(15)
    respond_with @departments
  end

  def new
    @department = @company.departments.build
  end

  def edit
  end

  def create
    @department = @company.departments.create(department_params)
    redirect_to_company
  end

  def update
    @department.update(department_params)
    redirect_to_company
  end

  def show
    @search = @department.employees.ransack(params[:q])
    @employees = @search.result(distinct: true).page(params[:page]).per(15)

    respond_to do |format|
      format.html
      format.csv { send_data @search.result.to_csv,
                             filename: "employees-#{ Date.today }.csv" }
    end
  end

  def destroy
    @department.destroy
    redirect_to_company
  end

  private

  def redirect_to_company
    respond_with @department, location: -> { company_path(@company) }
  end

  def set_department
    @department = @company.departments.find(params[:id])
  end

  def define_head
    @department_admin = @company.admin
    @company_admin = @company.admin
  end

  def department_params
    params.require(:department).permit(
        :name, :code, :parent_id)
  end

end
