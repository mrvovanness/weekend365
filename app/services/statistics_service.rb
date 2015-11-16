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

  def top_scoring_questions(answers)
    top_question_ids = Hash.new
    top_questions = Array.new

    @survey.offered_questions.includes(:offered_answers).each do |question|
      answers_count = question_answers(question, answers)
      total_answers = answer_distribution(question, answers).values.sum
      answer_percentage = ((answers_count.to_f / total_answers) * 100).round(0)

      if top_question_ids.values.min.nil? || top_question_ids.length < 5
        top_question_ids[question.id] = answer_percentage
      elsif top_question_ids.values.min <= answer_percentage
        top_question_ids.each do |key, value|
          if value == top_question_ids.values.min
            top_question_ids.delete(key)
            break;
          end
        end
        top_question_ids[question.id] = answer_percentage
      end
    end
    top_question_ids = top_question_ids.sort_by{|key, value| value}.reverse.to_h.keys
    top_question_ids.each do |question_id|
      top_questions << OfferedQuestion.find_by_id(question_id)
    end
    top_questions
  end

  def low_scoring_questions(answers)
    low_question_ids = Hash.new
    low_questions = Array.new

    @survey.offered_questions.includes(:offered_answers).each do |question|
      answers_count = question_answers(question, answers)
      total_answers = answer_distribution(question, answers).values.sum
      answer_percentage = ((answers_count.to_f / total_answers) * 100).round(0)
      if low_question_ids.values.max.nil? || low_question_ids.length < 5
        low_question_ids[question.id] = answer_percentage
      elsif low_question_ids.values.max >= answer_percentage
        low_question_ids.map do |key, value|
          if value == low_question_ids.values.max
            low_question_ids.delete(key)
            break
          end
        end
        low_question_ids[question.id] = answer_percentage
      end
    end
    low_question_ids = low_question_ids.sort_by{|key, value| value}.to_h.keys
    low_question_ids.each do |question_id|
      low_questions << OfferedQuestion.find_by_id(question_id)
    end

    low_questions
  end

  def question_answers(question, answers)
    top_scale_value1 = question.offered_answers.collect(&:value).max(2).first
    top_scale_value2 = question.offered_answers.collect(&:value).max(2).last
    top_offer_answers = question.offered_answers.where("value = ? OR value = ?", top_scale_value1, top_scale_value2)
    answers_count  = answers.where('offered_answer_id IN (?) AND result_id IN (?)', top_offer_answers.collect(&:id),
                                   @survey.results.where(offered_question: question).collect(&:id)).count rescue 0
  end

  def question_rate(question, answers)
    questions = OfferedQuestion.where(topic: topic)
    q_answers = answer_distribution(question, answers)
    good_answers = q_answers[4] + q_answers[5]
    { good: good_answers, total: q_answers.values.sum }
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

  def department_rate(department)
    employees = @survey.company.employees.where(department: department)
    good_answer_ids = OfferedAnswer.where(value: [4, 5])
    dep_answers = Answer.filter_by_employees(employees, @survey).count
    good_answers = Answer.filter_by_employees(employees, @survey)
    .where(offered_answer_id: good_answer_ids).count
    { good: good_answers, total: dep_answers }
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
