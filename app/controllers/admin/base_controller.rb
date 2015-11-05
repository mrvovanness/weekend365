class Admin::BaseController < ApplicationController
  before_action :authenticate_user!, :check_access
  skip_before_action :set_company

  private

  def check_access
    if current_user.is_usual?
      redirect_to surveys_path and return
    end
  end
end
