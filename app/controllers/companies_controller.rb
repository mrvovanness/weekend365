class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    redirect_to action: :index
  end
end
