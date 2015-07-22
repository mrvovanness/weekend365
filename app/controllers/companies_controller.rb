class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company

  def show
    all_employees = @company.employees.paginate(page: params[:page])
    if params[:query].present?
      @employees = all_employees.search(params[:query])
    else
      @employees = all_employees
    end
    respond_to do |format|
      format.html
      format.csv { send_data Employee.all.to_csv,
                   filename: "employees-#{ Date.today }.csv" }
    end
  end

  def edit
  end

  def update
    @company.update(company_params)
    respond_with @company
  end

  private

  def set_company
    @company = current_user.company
  end

  def company_params
    params.require(:company).permit(:name, :company_field_id, :office_address,
                                    :country, :description, :website,
                                    :employees_number, :employees_registered)
  end
end
