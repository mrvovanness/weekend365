FactoryGirl.define do
  factory :company_survey do
    title 'Your first survey'
    message 'Hello'

    factory :survey_with_linkert_questions do
      after(:create) do |survey|
        survey.offered_questions << create(:question_with_linkert_answers)
      end
    end

    factory :survey_with_tokens do
      transient do
        tokens_count 5
      end

      after(:create) do |survey, evaluator|
        create_list(:token, evaluator.tokens_count, company_survey: survey)
        create(:email_schedule, company_survey: survey)
      end
    end

    factory  :survey_with_schedule do
      after(:build) do |survey|
        build(:email_schedule, company_survey: survey)
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
