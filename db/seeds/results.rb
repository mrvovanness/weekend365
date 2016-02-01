puts 'Creating results for admin_company'

company = Company.find_by(name: 'Brazilian Tunes')

offered_surveys = OfferedSurvey.where({
  title: ['Offered survey number 0',
          'Offered survey number 1',
          'Overall Satisfaction']
})

offered_surveys.each do |offered_survey|
  puts "Creating company survey with offered survey #{offered_survey.title}"
  next if company.company_surveys.map(&:offered_survey_id).include?(offered_survey.id)
  company_survey = company.company_surveys.create(
    title: "#{offered_survey.title} for #{company.name}",
    repeat: true,
    offered_survey: offered_survey,
    email_schedule_attributes: {
      start_at: DateTime.current + 1.hour,
      repeat_every: 1,
      repeat_mode: 'w',
      finish_on: Date.today + 6.months,
      number_of_repeats: 13
    },
    message: offered_survey.description,
    offered_questions: offered_survey.offered_questions,
    employees: company.employees,
    emails_counter: company.employees.count,
    number_of_responses: company.employees.count
  )

  company_survey.employees.find_each do |employee|
    company_survey.offered_questions.find_each do |question|
      result = Result.create!(
        employee: employee,
        company_survey: company_survey,
        offered_question: question
      )

      if company_survey.answered_by_web_form?
        answer = result.answers.create!(
          offered_answer: OfferedAnswer.find([rand(1..3), 4, 5].sample ),
          comment: ['', 'I agree', 'I disagree'].sample
        )
        puts "Created result from employee #{employee.name}"\
             " on question #{question.title}"\
             " for survey #{company_survey.title}."\
             " Choose: #{answer.offered_answer.value},"\
             " comment: #{answer.comment}"
      else
        answer = result.answers.create!(
          offered_answer: OfferedAnswer.find([rand(1..8), 9, 10].sample),
          created_at: rand(6.months).seconds.ago,
          comment: ['', 'I agree', 'I disagree'].sample
        )
        puts "Created result from employee #{employee.name}"\
             " on question #{question.title}"\
             " for survey #{company_survey.title}."\
             " Choose: #{answer.offered_answer.value},"\
             " comment: #{answer.comment}"
      end
    end
  end
end

puts "Created #{Answer.count} answers"
