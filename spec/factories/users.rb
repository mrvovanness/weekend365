FactoryGirl.define do
  factory :user do
    email 'ex@mail.com'
    name FFaker::Name.name
    password 'bigsecret'
    password_confirmation { password }
    confirmed_at Time.zone.now
    company
  end
end
