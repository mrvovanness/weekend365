class AddDepartmentIdToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :department_id, :integer, index: true

    Employee.all.each do |employee|
      department = Department.find_by(code: employee.department_code)
      unless !!department
        department = Department.create!(name: employee.attributes.values_at(*['department']), code: employee.department_code)
      end
      employee.department_id = department.id
      employee.save validate: false #validation set false for employee first name and last name
    end
  end

  def self.down
    remove_column :employees, :department_id
  end
end
