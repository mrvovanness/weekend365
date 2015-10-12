FactoryGirl.define do
  factory :token do
    name SecureRandom.hex(10)
    expired false
    company_survey
  end
end
