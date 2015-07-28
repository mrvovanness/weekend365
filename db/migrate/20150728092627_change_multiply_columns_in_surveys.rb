class ChangeMultiplyColumnsInSurveys < ActiveRecord::Migration
  def change
    change_table :surveys do |t|
      t.boolean :repeat, null: false
      t.datetime :start_on
      t.datetime :finish_on
      t.integer :delivery_day
      t.datetime :next_delivery
    end
  end
end
