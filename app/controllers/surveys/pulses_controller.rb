class Surveys::PulsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, except: [:index, :new, :create]
  respond_to :json, only: :update_employees

  def index
    @search = @company.company_surveys.ransack(params[:q])
    @surveys = @search.result(distinct: true).decorate
  end

  def new
    load_offered_survey
    @survey = @company.company_surveys.build.decorate
  end

  def edit
    load_offered_survey
  end

  def create
    @survey = @company.company_surveys.create(survey_params).decorate
    load_offered_survey if @survey.errors.present?
    respond_with @survey,
      location: -> { preview_surveys_pulse_path(@survey) }
  end

  def update
    @survey.update(survey_params)
    load_offered_survey if @survey.errors.present?
    respond_with @survey,
      location: -> { preview_surveys_pulse_path(@survey) }
  end

  def destroy
    @survey.destroy
    respond_with @survey, location: -> { surveys_path }
  end

  def preview
  end

  def preview_email
    @token = Token.new(name: 'preview')
    @answers = @survey.offered_questions.first.offered_answers
    @employee = Employee.new(id: 1)
    render 'surveys_mailer/send_survey',
      layout: false
  end

  def update_employees
    @survey.update_attributes!(survey_params)
    respond_with @survey.employees.count
  end

  def comments
    @answers = @survey.answers.includes(:offered_answer)
  end

  private

  def survey_params
    params.require(:company_survey).permit(
      :title, :start_on, :time, :finish_on,
      :number_of_repeats, :repeat_every, :locale,
      :repeat_mode, :message, :skip_callback,
      :employee_ids => [], :offered_question_ids => [])
  end

  def set_survey
    @survey = @company.company_surveys.find(params[:id]).decorate
  end

  def load_offered_survey
    @offered_survey = OfferedSurvey.first
    @offered_questions = @offered_survey.offered_questions
      .includes(:offered_answers).uniq
  end
end
