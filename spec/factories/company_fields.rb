FactoryGirl.define do
  factory :company_field do
    name FFaker::Company.suffix
  end
end
