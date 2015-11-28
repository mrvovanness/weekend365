class AddOfficeLocationIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :office_location_id, :integer
  end
end
