FactoryGirl.define do
  factory :employee do
    name FFaker::Name.name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
    company
  end

end
