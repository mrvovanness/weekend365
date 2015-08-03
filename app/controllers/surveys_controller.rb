class SurveysController < ApplicationController
  before_action :set_company, :authenticate_user!

  def index
    @surveys = @company.surveys
  end

  def new
    @survey = @company.surveys.build
    # @survey.questions.build
  end

  def create
    @survey = @company.surveys.create(survey_params)
    respond_with @survey
  end

  private

  def survey_params
    params.require(:survey).permit(
      :title, :start_on, :start_at,
      :finish_on, :number_of_repeats, :repeat)
  end

  def set_company
    @company = current_user.company
  end

end
