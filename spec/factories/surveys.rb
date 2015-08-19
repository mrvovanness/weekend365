FactoryGirl.define do
  factory :survey do
    title 'Your first survey'
    start_at DateTime.now + 1.hour
    next_delivery_at DateTime.now + 1.hour
    number_of_repeats 2
    repeat_mode 'd'
    repeat_every 3
    message 'Hello'
    counter 0

    factory :survey_with_id
    id 1

    factory :survey_with_questions do
      transient do
        questions_count 1
      end

      after(:create) do |survey, evaluator|
        create_list(:question, evaluator.questions_count, survey: survey)
      end
    end
  end
end
