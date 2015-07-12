class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company

  respond_to :html

  def show
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
    params.require(:company).permit(:name, :field, :office_address,
                                    :country, :description, :website,
                                    :employees_number, :employees_registered)
  end
end
