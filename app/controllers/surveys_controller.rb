class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, except: [:index, :new, :update_employees]
  respond_to :json, only: :update_employees

  def index
    @search = @company.company_surveys.includes(:email_schedule, :offered_survey).completed.ransack(params[:q])
    @completed_surveys = @search.result.order('email_schedules.start_at DESC').decorate

    @search = @company.company_surveys.includes(:email_schedule, :offered_survey).current.ransack(params[:q])
    @current_surveys = @search.result.order('email_schedules.start_at DESC').decorate
  end

  def new
    @offered_surveys = OfferedSurvey.includes(:translations).order(created_at: :asc)
  end

  def destroy
    @survey.destroy
    respond_with @survey, location: -> { surveys_path }
  end

  def update_employees
    @survey = CompanySurvey.find(params[:id])
    @survey.update_attributes!(
      params.require(:company_survey).permit(employee_ids: [])
    )
  end

  def email_preview
    token = Token.new(name: 'preview')
    @token = token.name
    @answers = @survey.offered_questions.first.offered_answers
    @employee = Employee.new(id: 1)
    @company_admin = @survey.company.admin

    if @survey.answered_by_web_form?
      render 'surveys_mailer/send_web_survey',
        layout: 'surveys_mailer'
    else
      render 'surveys_mailer/send_email_survey',
        layout: 'surveys_mailer'
    end
  end

  private

  def set_survey
    @survey = @company.company_surveys.includes(
      offered_questions: :translations
    ).find(params[:id]).decorate
  end
end

