class AnswersController < ApplicationController

  def add_answer
    case
    when params[:token].present?
      token = Token.find_by(name: params[:token])
      if token.nil? || token.expired
        redirect_to root_path
      else
        @question = Question.find(params[:question_id])
        @question.answers.create(mark: params[:mark])
        token.update(expired: true)
      end
    when params[:token].nil?
      redirect_to root_path
    end
  end
end
