class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company

  respond_to :html

  def show
    @employees = @company.employees.all
  end

  def edit
    file = File.open('app/views/companies/fields_list.txt')
    @options = []
    file.each do |line|
      @options << line
    end
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
    params.require(:company).permit(:name, :field, :office_address,
                                    :country, :description, :website,
                                    :employees_number, :employees_registered)
  end
end
