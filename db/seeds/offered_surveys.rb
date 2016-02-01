puts "Generating offered surveys (web based)..."

#default answers
(1..10).each do |n|
  OfferedAnswer.find_or_create_by(value: n)
end

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

puts "Generating offered surveys (email based)..."
email_question = OfferedQuestion.find_or_create_by(title: "How are you satisfied with your job?") do |question|
  question.topic = "Overall satisfaction"
  question.subtopic = "Main"
  question.form_of_answers = "1-10 scale"
end

email_survey = OfferedSurvey.find_or_create_by(title: "Overall Satisfaction") do |survey|
  survey.description = "Email survey"
  survey.answers_through = 'email'
  survey.offered_questions.push(email_question)
end
