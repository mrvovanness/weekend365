FactoryGirl.define do
  factory :company do
    name FFaker::Company.name
    field FFaker::Company.suffix
    user
  end
end
