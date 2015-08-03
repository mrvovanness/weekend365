class ChangeMultiplyColumnsInSurveys < ActiveRecord::Migration
  def change
    change_table :surveys do |t|
      t.boolean :repeat
      t.date :start_on
      t.time :start_at
      t.date :finish_on
      t.integer :number_of_repeats
      t.datetime :next_delivery_at
    end
  end
end
