class ResultsController < ApplicationController
  layout 'home'
  def add_result
    case
    when params[:token].present?
      token = Token.find_by(name: params[:token])
      if token.nil? || token.expired
        redirect_to root_path
      else
        result = Result.create!(
          employee_id: params[:employee_id],
          offered_question_id: params[:offered_question_id],
          company_survey_id: params[:company_survey_id]
        )
        @answer = result.answers.create(
          offered_answer_id: params[:offered_answer_id]
        )
        token.update(expired: true)
        survey = token.company_survey
        survey.skip_callback = true
        survey.increment!(:number_of_responses)
      end
    when params[:token].nil?
      redirect_to root_path
    end
  end

  def add_open_question
    if params[:answer][:open_question].present?
      answer = Answer.find(params[:id])
      answer.update(open_question: params[:answer][:open_question])
    else
      redirect_to root_path
    end
  end
end
