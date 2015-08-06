class AddColumnToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :repeat_every, :integer
    add_column :surveys, :repeat_mode, :string
  end
end
