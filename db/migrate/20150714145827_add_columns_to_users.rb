class AddColumnsToUsers < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.string :position
      t.boolean :selected_to_survey
      t.string :email, unique: true
      t.integer :company_id
      t.index :company_id
    end
  end
end
