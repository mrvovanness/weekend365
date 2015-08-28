#create default pulse survey
survey = PulseSurvey.find_or_create_by(title: 'Job Satisfaction')

survey.offered_questions.find_or_create_by(
  title: 'Overall, how satisfied are you with your job?',
  type: 'ScaledQuestion'
)

survey.offered_questions.find_or_create_by(
  title: 'How do you evaluate your department\'s management?',
  type: 'ScaledQuestion'
)

ScaledQuestion.all.each do |question|
  (1..10).each do |n|
    question.offered_answers.find_or_create_by(value: n.to_s)
  end
end
puts OfferedSurvey.count
puts OfferedQuestion.count
puts OfferedAnswer.count

