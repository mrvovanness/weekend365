FactoryGirl.define do

  factory :employee do
    sequence(:first_name, 5) { |n| [FFaker::Name.first_name, n.to_s].join('') }
    sequence(:last_name, 5) { |n| [FFaker::Name.last_name, n.to_s].join('') }
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
    position ['Team member', 'Manager'].sample
    department
  end

  factory :second_employee, parent: :employee do
    first_name FFaker::Name.first_name
    last_name FFaker::Name.last_name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
    department
  end

  factory :third_employee, parent: :employee do
    first_name FFaker::Name.first_name
    last_name FFaker::Name.last_name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
    department
  end
end
