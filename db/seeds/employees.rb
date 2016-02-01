# rake db:seed:employees
# Default admin company
company = Company.find_by(name: 'Brazilian Tunes')
puts "Creating fake employees for #{ company.name } ..."

director_board = company.departments.create name: "Director Board", code: "001"
%w(Sales Marketing HR IT Finances PR Delivery QA DevOps Admin Engineers QT).each_with_index do |item, index|
  company.departments.create! name: item,
                             code: "00#{index + 2}",
                             parent: director_board
end


100.times do
  new_employee = company.employees.new(
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    email: FFaker::Internet.disposable_email,
    position: ['Team Member', 'Manager'].sample,
    gender: ['male', 'female'].sample,
    birthday: rand(40.years).seconds.ago,
    country: ['JP', 'BR'].sample,
    department: company.departments.all.sample)

  new_employee.save(validate: false)
end
