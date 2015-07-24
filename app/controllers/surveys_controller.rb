class SurveysController < ApplicationController
  before_action :set_company

  def index
    @surveys = @company.surveys
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :status,
                                   :alarm, :start_date, :frequency)
  end

  def set_company
    @company = current_user.company
  end
end
