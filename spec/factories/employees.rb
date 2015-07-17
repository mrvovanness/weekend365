FactoryGirl.define do
  factory :employee do
    name FFaker::Name.name
    email FFaker::Internet.email
    company
  end

end
