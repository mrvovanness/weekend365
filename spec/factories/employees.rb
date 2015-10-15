FactoryGirl.define do

  factory :employee do
    name FFaker::Name.name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
    department %w(IT Sales Security Finance).sample
    position ['Team member', 'Manager'].sample
    company
  end

  factory :second_employee, parent: :employee do
    name FFaker::Name.name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
  end

  factory :third_employee, parent: :employee do
    name FFaker::Name.name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
  end
end
