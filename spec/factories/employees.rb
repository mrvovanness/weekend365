FactoryGirl.define do

  factory :employee do
    name FFaker::Name.name
    sequence(:email, 10) { |n| "ex_#{n}@mail.com" }
    department %w(IT Sales Security Finance).sample
    position ['Team member', 'Manager'].sample
    company
  end

end
