class SetDefaultForColumnInEmployees < ActiveRecord::Migration
  def change
    change_column :employees, :selected_to_survey, :boolean, default: false
  end
end
