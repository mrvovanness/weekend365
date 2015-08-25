# rake db:seed:surveys

company = Company.find_or_create_by(name: 'Coca-Cola')
puts "creating fake surveys for company #{ company.name } ..."
10.times do
  new_survey = company.surveys.new(
    title: FFaker::Lorem.phrase,
    start_at: Date.today + [*1..10].sample,
    repeat: true)
  new_survey.save(validate: false)
end
