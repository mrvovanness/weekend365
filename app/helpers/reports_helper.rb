module ReportsHelper
  def department_rate(department, survey)
    rate = survey.get_statistics.department_rate(department)
    good_answers = rate[:good]
    total_answers = rate[:total]
    rate_in_percent = total_answers > 0 ? number_to_percentage(good_answers.to_f / total_answers * 100, precision: 0) : '0%'
    "#{rate_in_percent} (#{good_answers} of #{total_answers})"
  end

  def department_participation(survey, department, num_of_employees)
    emp_ids = survey.employees.where(department: department).pluck(:id)
    dep_answers = survey.results.where(employee_id: emp_ids).pluck(:employee_id).uniq.count
    participation = number_to_percentage(dep_answers.to_f / num_of_employees * 100, precision: 0)
    "#{participation} (#{dep_answers} of #{num_of_employees})"
  end

  def question_select(survey, answers)
    result_ids = answers.with_comments.pluck(:result_id)
    off_question_ids = Result.where(id: result_ids).pluck(:offered_question_id)
    select_tag :question,
      options_for_select(
        survey.offered_questions
          .includes(:translations)
          .where(id: off_question_ids)
          .order(:title)
          .collect { |a| [a.title, a.id] }
      ),
      prompt: 'Choose question',
      class: 'selectable',
      id: 'question-select'
  end

  def scatter_obj(company_survey)
    qa_hashes = company_survey.get_charts.correlation
    cor_array = qa_hashes.map { |hash| hash[:x] }
    cc_sum = cor_array.inject { |sum, n| sum + n }
    cc_average = (cc_sum/qa_hashes.size).round(2)
    average_of_base_question = qa_hashes.select {|q| q[:id] == 91 }.first[:y]

    strength_q_ids = qa_hashes.select do |hash|
      hash[:x] > cc_average && hash[:y] > average_of_base_question
    end.map { |hash| hash[:id] }

    weak_q_ids = qa_hashes.select do |hash|
      hash[:x] > cc_average && hash[:y] < average_of_base_question
    end.map { |hash| hash[:id] }

    @strength_questions = company_survey.offered_questions.find(strength_q_ids)
    @weak_questions = company_survey.offered_questions.find(weak_q_ids)

    LazyHighCharts::HighChart.new('graph', { :style => "height: 490px; width:760px; margin: 50px auto;" }) do |f|
      f.series(type: 'scatter',
               name: 'question',
               data: qa_hashes)
      f.options[:xAxis] = { title:
                              { enabled: true, text: 'Importance' },
                            plot_lines:
                              [{ value: cc_average,
                               width: 2, color: 'black' }] }
      f.options[:yAxis] = { title:
                              { enabled: true, text: 'Satisfaction'},
                            plot_lines:
                              [{ value: average_of_base_question,
                                 width: 2, color: 'black' }] }
      f.options[:tooltip] = { enabled: true,
                              pointFormat:
                                "{point.name}<br>Satisfaction: {point.y}<br>Importance: {point.x}"}
    end
  end
end
