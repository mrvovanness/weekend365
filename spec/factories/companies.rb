FactoryGirl.define do
  factory :company do
    name FFaker::Company.name
    user
    company_field
  end
end
