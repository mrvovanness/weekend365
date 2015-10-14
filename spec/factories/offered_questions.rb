FactoryGirl.define do
  factory :offered_question do
    title 'Test'

    factory :question_with_answers do
      after(:create) do |question|
        10.times do
          question.offered_answers << create(:offered_answer)
        end
      end
    end
  end
end
