class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :define_date_filter, only: :show

  def show
    @survey = @company.company_surveys.includes(
      offered_questions: :translations, answers: :offered_answer
    ).find(params[:id]).decorate
    @search = @company.employees.ransack(params[:q])
    @answers = Answer.filter_by_employees(@search.result, @survey)
      .ransack(@date_filter).result
    @comments = @survey.answers.map(&:comment).compact.last(3)
    @period = params[:period] || (@survey.weekly? ? 'week' : 'day')
    @active_tab = params[:active_tab] || 0

    if @survey.answered_by_web_form?
      @stat = @survey.get_statistics
      if @answers.present? and @survey.results.present?
        @top_q = @stat.top_scoring_questions(@answers)
        @low_q = @stat.low_scoring_questions(@answers)
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data @answers.to_csv,
        filename: "survey-#{ Date.today }.csv" }
    end
  end

  private

  def define_date_filter
    @date_filter = {
      created_at_gteq: DateTime.current - 1.month,
      created_at_lteq: DateTime.current
    }
    [:created_at_gteq, :created_at_lteq].each do |key|
      if params[key].present?
        @date_filter[key] = params[key]
      end
    end
  end
end
