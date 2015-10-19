FactoryGirl.define do
  factory :email_schedule do
    start_on Date.today.strftime('%Y-%m-%d')
    time (Time.current + 1.hour).strftime('%H:%M')
    number_of_repeats 2
    repeat_mode 'd'
    repeat_every 3
    company_survey
  end
end
