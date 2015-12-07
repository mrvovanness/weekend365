class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :code
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true

      # optional fields
      t.integer :depth, :null => false, :default => 0
      t.integer :children_count, :null => false, :default => 0
      t.references :company

      t.timestamps null: false
    end

    Employee.all.each do |employee|
      Department.create!(name: employee.attributes.values_at(*['department']), code: employee.department_code)
    end
  end
end
