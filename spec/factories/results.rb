FactoryGirl.define do
  factory :result do
    offered_question
    transient do
      answers_count 1
    end

    after(:create) do |result, evaluator|
      create_list(:answer, evaluator.answers_count, result: result)
    end
  end
end
