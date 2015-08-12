class AddCounterToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :counter, :integer, default: 0
  end
end
