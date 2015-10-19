FactoryGirl.define do
  factory :email_schedule do
    start_on Date.current.strftime('%Y-%m-%d')
    time (Time.current + 1.minute).strftime('%H:%M')
    number_of_repeats 2
    repeat_mode 'd'
    repeat_every 3
    company_survey
  end
end
