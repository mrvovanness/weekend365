# rake db:seed:employees_surveys
# Default admin company
company = Company.find_by(name: 'Brazilian Tunes')
puts "Creating fake employees for #{ company.name } ..."
100.times do
  new_employee = company.employees.new(
    name: FFaker::Name.name,
    email: FFaker::Internet.disposable_email,
    position: ['Team Member', 'Manager'].sample,
    department: ['Sales', 'HR', 'Security', 'IT', 'Finance'].sample)

  new_employee.save(validate: false)
end
