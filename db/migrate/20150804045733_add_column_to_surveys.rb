class AddColumnToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :message, :text
  end
end
