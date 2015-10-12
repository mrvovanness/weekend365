FactoryGirl.define do
  factory :company_survey do
    title 'Your first survey'
    number_of_repeats 2
    repeat_mode 'd'
    repeat_every 3
    message 'Hello'
    start_on Date.today.strftime('%Y-%m-%d')
    time (Time.current + 1.hour).strftime('%H:%M')

    factory :survey_with_finish_on do
      finish_on Date.today + 1.year
    end

    factory :survey_with_questions do
      transient do
        questions_count 1
      end

      after(:create) do |survey, evaluator|
        create_list(:question, evaluator.questions_count, survey: survey)
      end
    end

    factory :survey_with_tokens do
      transient do
        tokens_count 5
      end

      after(:create) do |survey, evaluator|
        create_list(:token, evaluator.tokens_count, company_survey: survey)
      end
    end

    factory :survey_with_results do
      company
      transient do
        results_count 5
      end

      after(:create) do |survey, evaluator|
        survey.offered_questions = [create(:offered_question)]
        create_list(:result, evaluator.results_count,
                    company_survey: survey,
                    offered_question: survey.offered_questions.first)
      end
    end

  end
end
