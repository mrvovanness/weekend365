module Admin
  class OfferedQuestionsController < Admin::BaseController
    before_action :set_question, only: [:edit, :update, :destroy]

    def index
      @questions = OfferedQuestion.includes(:translations)
    end

    def show
    end

    def new
      @question = OfferedQuestion.new
    end

    def edit
    end

    def create
      @question = OfferedQuestion.create(question_params)
      respond_with :admin, @question
    end

    def update
      @question.update(question_params)
      respond_with :admin, @question
    end

    def destroy
      @question.destroy
      respond_with :admin, @question
    end

    private

    def question_params
      params.require(:offered_question)
        .permit(:title,
                :topic,
                :subtopic,
                offered_answer_ids: [])
    end

    def set_question
      @question = OfferedQuestion.find(params[:id])
    end
  end
end
