class RenameDepartmentsToEmployees < ActiveRecord::Migration
  def change
    rename_column :employees, :department, :department_old
  end
end
