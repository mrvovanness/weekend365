puts "migrating data from company_surveys to email_schedules"

CompanySurvey.find_each do |survey|
  schedule = survey.build_email_schedule(
    start_at: survey.start_at_old,
    finish_on: survey.finish_on_old,
    number_of_repeats: survey.number_of_repeats_old,
    repeat_mode: survey.repeat_mode_old,
    repeat_every: survey.repeat_every_old,
    next_delivery_at: survey.next_delivery_at_old
  )
  schedule.save!(validate: false)
end

puts "Number of company surveys: #{CompanySurvey.count}"
puts "Number of schedules: #{EmailSchedule.count}"
