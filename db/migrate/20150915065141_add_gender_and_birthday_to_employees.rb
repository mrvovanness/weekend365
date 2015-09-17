class AddGenderAndBirthdayToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.date :birthday
      t.string :gender
      t.string :country
    end
  end
end
