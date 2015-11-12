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
end