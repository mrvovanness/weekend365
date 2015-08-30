class ResultsController < ApplicationController

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
        )
        result.answers.create(
          offered_answer_id: params[:offered_answer_id]
        )
        token.update(expired: true)
      end
    when params[:token].nil?
      redirect_to root_path
    end
  end
end
