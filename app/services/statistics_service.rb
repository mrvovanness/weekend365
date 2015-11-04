class StatisticsService
  def initialize(survey)
    @survey = survey
  end

  def average
    OfferedAnswer.joins(:answers)
      .where(answers: { result: @survey.results })
      .average('value').to_f.round(1)
  end

  def count
    OfferedAnswer.joins(:answers)
      .where(answers: { result: @survey.results }).count
  end

  def rate
    if @survey.emails_counter > 0
      @survey.number_of_responses.to_f / @survey.emails_counter * 100
    else
      0
    end
  end

  def average_by_country
    OfferedAnswer.joins(:answers)
      .where(answers: { result: all_results_of_one_country })
      .average('value').to_f.round(1)
  end

  def all_results_of_one_country(date_filter='')
    if date_filter.present?
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_country }
        ).ransack(date_filter).result
    else
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_country }
      )
    end
  end

  def all_companies_of_one_country
    Company.where(country: @survey.company.country)
  end

  def average_by_industry
    OfferedAnswer.joins(:answers)
      .where(answers: { result: all_results_of_one_industry })
      .average('value').to_f.round(1)
  end

  def all_results_of_one_industry(date_filter='')
    if date_filter.present?
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_industry }
        ).ransack(date_filter).result
    else
      Result.joins(:company_survey).where(
        offered_question_id: @survey.offered_questions,
        company_surveys: { company_id: all_companies_of_one_industry }
      )
    end
  end

  def all_companies_of_one_industry
    Company.where(company_field: @survey.company.company_field)
  end

  def latest_reply
    begin
      Answer.where(result: @survey.results)
        .order(created_at: :desc).first
        .created_at.try(:strftime, '%b.%dth/%Y at %H:%M')
    rescue
      'none'
    end
  end

  def answer_distribution(question, answers)
    off_answers = question.offered_answers.order(:value)
    distribution = off_answers.map do |off_answer|
      [
        off_answer.value,
        answers.where(
          offered_answer: off_answer,
          result: @survey.results.where(offered_question: question)
          ).count
      ]
    end
    Hash[distribution]
  end

  def topic_rate(topic, answers)
    questions = OfferedQuestion.where(topic: topic)
    t_answers = {}
    questions.each do |question|
      q_answers = answer_distribution(question, answers)
      t_answers = t_answers.merge(q_answers) { |key, oldval, newval| oldval + newval }
    end
    rate = t_answers.values.sum > 0 ? (t_answers[4] + t_answers[5]).to_f / t_answers.values.sum * 100 : 0
    return rate, t_answers.values.sum
  end

  def survey_rate
    good_answer_ids = OfferedAnswer.where(value: [4, 5])
    good_answers = @survey.answers.where(offered_answer_id: good_answer_ids).count
    if @survey.answers.count > 0 
      good_answers.to_f / @survey.answers.count * 100
    else
      0
    end
  end
end
