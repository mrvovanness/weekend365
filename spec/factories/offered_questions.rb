FactoryGirl.define do
  factory :offered_question do
    title 'Test'
    topic 'Test topic'

    factory :question_with_answers do
      after(:create) do |question|
        10.times do
          question.offered_answers << create(:offered_answer)
        end
      end
    end

    factory :question_with_linkert_answers do
      after(:create) do |question|
        n = 1
        5.times do
          question.offered_answers << create(:offered_answer, value: n)
          n += 1
        end
      end
    end

  end
end
