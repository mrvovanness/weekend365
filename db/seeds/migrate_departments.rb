Company.all.each do |company|
  employees = Employee.where(company_id: company.id)
  employees.each do |employee|
    department = company.departments.find_or_create_by!(name: employee.department_old)
    employee.update_column(:department_id, department.id)
  end
end
puts "Number of departments #{Department.count}"

