# to run this: rake db:seed:employees_surveys

# Default admin company 
company = Company.find_or_create_by(name: 'Coca-Cola')

puts "Creating fake employees for #{ company.name } ..."
100.times do
  new_employee = company.employees.new(
    name: FFaker::Name.name,
    email: FFaker::Internet.disposable_email,
    position: ['Team Member', 'Manager'].sample,
    department: ['Sales', 'HR', 'Security', 'IT', 'Finance'].sample)

  new_employee.save(validate: false)
end

puts "creating fake surveys for company #{ company.name } ..."
10.times do
  new_survey = company.surveys.new(
    title: FFaker::Lorem.phrase,
    start_on: Date.today + [*1..10].sample,
    repeat: true)

  new_survey.save(validate: false)
end

puts "Number of fake employees created - #{ company.employees.count } "\
  "for company #{ company.name } of user #{company.user.email} "\
  "with #{ company.surveys.count } surveys"


