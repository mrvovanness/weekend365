class ResultsController < ApplicationController
  layout 'devise'

  before_action :check_token, only: [:new, :add_result]

  def new
    @survey = CompanySurvey.find(params[:company_survey_id])
    @result = @survey.results.build
    @result.answers.build
    @token = params[:token]
    @employee_id = params[:employee_id]
    render layout: 'results'
  end

  def create
    survey = CompanySurvey.find(params[:company_survey_id])
    survey.update(survey_params)
    token = Token.find_by(name: params[:token])
    token.update!(expired: true) unless Rails.env.development?
    survey.increment!(:number_of_responses)
    redirect_to thanks_for_comment_path
  end

  def add_result
    token = Token.find_by(name: params[:token])
    result = Result.create!(
      employee_id: params[:employee_id],
      offered_question_id: params[:offered_question_id],
      company_survey_id: params[:company_survey_id]
    )
    @answer = result.answers.create(
      offered_answer_id: params[:offered_answer_id]
    )
    token.update(expired: true) unless Rails.env.development?
    survey = token.company_survey
    survey.increment!(:number_of_responses)
  end

  def add_comment
    if params[:answer][:comment].present?
      answer = Answer.find(params[:id])
      answer.update!(comment: params[:answer][:comment])
    end
    redirect_to thanks_for_comment_path
  end

  private

  def check_token
    case
    when params[:token].present?
      @token = Token.find_by(name: params[:token])
      if @token.nil? || @token.expired
        flash[:info] = t('flash.token_expired') unless params[:token] == 'preview'
        redirect_to root_path unless params[:token] == 'preview'
      end
    when params[:token].nil?
      redirect_to root_path
    end
  end

  def survey_params
    params.require(:company_survey).permit(
      results_attributes: [
        :company_survey_id,
        :offered_question_id,
        :employee_id,
        answers_attributes: [
          :comment,
          :offered_answer_id
        ]
      ]
    )
  end
end
