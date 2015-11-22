class AddColumnsToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :first_name, :string
    add_column :employees, :last_name, :string
    add_column :employees, :joining_date, :date
    add_column :employees, :department_code, :string
    add_column :employees, :ethnicity, :string

    Employee.all.each do |employee|
      employee.first_name = employee.name.split(' ')[0]
      employee.last_name = employee.name.split(' ')[1]
      employee.save
    end

    sql = <<-SQL
      CREATE FUNCTION build_employee_name_func () RETURNS trigger AS '
      BEGIN
 	      NEW.name = NEW.first_name || '' '' || NEW.last_name;
 	      RETURN NEW;
      END;
      ' LANGUAGE plpgsql;


      CREATE TRIGGER build_employee_name_trg BEFORE INSERT OR UPDATE
      ON employees FOR EACH ROW
      EXECUTE PROCEDURE build_employee_name_func ();

      CREATE INDEX name_fulltext_idx ON employees
        USING gin(to_tsvector('portuguese', name));
    SQL

    execute sql
  end

  def self.down
    remove_column :employees, :ethnicity
    remove_column :employees, :department_code
    remove_column :employees, :joining_date
    remove_column :employees, :last_name
    remove_column :employees, :first_name
    execute "DROP TRIGGER build_employee_name_trg ON employees"
    execute "DROP FUNCTION build_employee_name_func()"
    remove_index :employees, name: 'name_fulltext_idx'
  end
end
