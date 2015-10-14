module Admin
  class OfferedSurveysController < Admin::BaseController
    before_action :set_survey, only: [:edit, :update, :destroy]

    def index
      @surveys = OfferedSurvey.includes(:translations)
    end

    def show
    end

    def new
      @survey = OfferedSurvey.new
    end

    def edit
    end

    def create
      @survey = OfferedSurvey.create(survey_params)
      respond_with :admin, @survey
    end

    def update
      @survey.update(survey_params)
      respond_with :admin, @survey
    end

    def destroy
      @survey.destroy
      respond_with :admin, @survey
    end

    private

    def survey_params
      params.require(:offered_survey)
        .permit(:title,
                :description,
                offered_question_ids: [])
    end

    def set_survey
      @survey = OfferedSurvey.find(params[:id])
    end
  end
end
