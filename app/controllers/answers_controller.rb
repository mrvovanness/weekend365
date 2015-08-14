class AnswersController < ApplicationController

  def add_answer
    if params[:question_id].nil? && params[:mark].nil?
      redirect_to root_path and return
    end

    @question = Question.find(params[:question_id])
    @question.answers.create(mark: params[:mark])
  end
end
