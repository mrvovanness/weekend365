FactoryGirl.define do
  factory :offered_survey do
    title 'Test'

    factory :offered_survey_with_offered_questions do
      after(:create) do |survey|
        10.times do
          survey.offered_questions << create(:offered_question)
        end
      end
    end
  end
end
