FactoryGirl.define do
  factory :user do
    email 'ex@mail.com'
    password 'bigsecret'
    password_confirmation { password }
    confirmed_at Time.now
  end
end
