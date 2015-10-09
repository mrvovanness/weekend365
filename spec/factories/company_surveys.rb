FactoryGirl.define do
  factory :company_survey do
    title 'Your first survey'
    number_of_repeats 2
    repeat_mode 'd'
    repeat_every 3
    message 'Hello'
    counter 0
    start_on Date.today.strftime('%Y-%m-%d')
    time (Time.current + 1.hour).strftime('%H:%M')

    factory :survey_with_id
    id 1

    factory :survey_with_finish_on
    finish_on Date.today + 1.year

    factory :survey_with_questions do
      transient do
        questions_count 1
      end

      after(:create) do |survey, evaluator|
        create_list(:question, evaluator.questions_count, survey: survey)
      end
    end

    factory :survey_with_results do
    end

  end
end
