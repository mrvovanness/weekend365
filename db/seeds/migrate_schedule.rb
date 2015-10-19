puts "migrating data from company_surveys to email_schedules"

CompanySurvey.find_each do |survey|
  schedule = survey.build_email_schedule
  schedule.start_at = survey.start_at
  schedule.finish_on = survey.finish_on
  schedule.number_of_repeats = survey.number_of_repeats
  schedule.repeat_mode = survey.repeat_mode
  schedule.repeat_every = survey.repeat_every
  schedule.next_delivery_at = survey.next_delivery_at
  schedule.save
end

puts "Number of companies: #{CompanySurvey.count}"
puts "Number of schedules: #{EmailSchedule.count}"
