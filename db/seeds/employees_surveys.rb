# to run this: rake db:seed:employees_surveys

# Default admin company 
company = Company.find_or_create_by(name: 'Coca-Cola') do |company|
  company.field = 'foods'
end

puts "Creating fake employees for #{ company.name } ..."
100.times do
  company.employees.create!(name: FFaker::Name.name,
                            email: FFaker::Internet.disposable_email,
                            position: ['Team Member', 'Manager'].sample,
                            department: ['Sales', 'HR', 'Security', 'IT', 'Finance'].sample)
end

puts "creating fake surveys for company #{ company.name } ..."
10.times do
  company.surveys.create!(title: FFaker::Lorem.phrase,
                          start_date: Date.today + [*1..10].sample)
end

puts "Number of fake employees created - #{ company.employees.count } "\
  "for company #{ company.name } of user #{company.user.email} "\
  "with #{ company.surveys.count } surveys"


