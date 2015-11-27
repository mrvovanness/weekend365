module SharedMethods

  # => [{:id=>1, :title=>"Title", :answers=>[2,3,5,1, ...]}, {...}]
  def all_answers_by_question
    @survey.answers
      .includes(:offered_answer, result: { offered_question: :translations })
      .group_by { |answer| answer.result.offered_question }
      .map do |k, v|
        {
          id: k.id,
          title: k.title,
          base: k.base_for_correlation,
          answers: v.map { |a| a.offered_answer.value }
        }
      end
  end

  def find_correlation(measured_question_answers, base_question_answers)
    first_set = measured_question_answers.to_vector
    second_set = base_question_answers.to_vector
    Statsample::Bivariate::Pearson.new(first_set, second_set).r.round(2)
  end

  def find_average_of_answers(answers_array)
    (answers_array.inject(&:+).to_f/answers_array.size).round(2)
  end

end
