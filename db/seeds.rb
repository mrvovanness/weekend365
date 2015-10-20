#create default pulse survey with questions and offered answers
load "#{Rails.root}/db/seeds/articles.rb"

survey = OfferedSurvey.find_or_create_by(title: 'Job Satisfaction')

question1 = survey.offered_questions.find_or_create_by(
 title: 'Overall, how satisfied are you with your job?'
)

question2 = survey.offered_questions.find_or_create_by(
 title: "How do you evaluate your department's management?"
)

question3 = survey.offered_questions.find_or_create_by(
 title: 'Assess your mood right now?'
)

I18n.locale = :ja

survey.update_attribute(:title, '仕事の満足度サーベイ')
question1.update_attribute(:title, 'あなたは今の仕事を総合的にみて、どの程度満足していますか？')
question2.update_attribute(:title, 'put translation here')
question3.update_attribute(:title, 'put translation here')

I18n.locale = :pt

survey.update_attribute(:title, 'Pesquisa de Satisfação no Trabalho')
question1.update_attribute(:title, 'Levando tudo em consideração, o quão satisfeito você está no trabalho?')
question2.update_attribute(:title, 'put translation here')
question3.update_attribute(:title, 'put translation here')


(1..10).each do |n|
  answer = OfferedAnswer.find_or_create_by(value: n)
  SqaAssignment.find_or_create_by(
    offered_question: question1,
    offered_answer: answer
  )
  SqaAssignment.find_or_create_by(
    offered_question: question2,
    offered_answer: answer
  )
  SqaAssignment.find_or_create_by(
    offered_question: question3,
    offered_answer: answer
  )
end

puts "surveys: #{OfferedSurvey.count}"
puts "questions: #{OfferedQuestion.count}"
puts "answers: #{OfferedAnswer.count}"
puts "sqa assignments: #{SqaAssignment.count}"
