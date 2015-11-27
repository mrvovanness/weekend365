puts "Generating offered surveys (web based)..."

questions = []
20.times do |n|
  questions << OfferedQuestion.find_or_create_by(title: "Offered question number #{n}") do |question|
    question.topic = "topic #{rand(1..5)}"
    question.subtopic = "subtopic #{rand(1..5)}"
    question.form_of_answers = '1-5 scale'
  end
end

questions.first.update(base_for_correlation: true)

surveys = []
2.times do |n|
  surveys << OfferedSurvey.find_or_create_by(title: "Offered survey number #{n}") do |survey|
    survey.description = "Description for offered survey number #{n}"
    survey.answers_through = 'web'
    survey.offered_questions = questions
  end
end

puts "Created #{surveys.size} offered surveys,"\
     " each with #{questions.size} questions"
