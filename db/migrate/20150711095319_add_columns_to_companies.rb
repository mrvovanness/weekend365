class AddColumnsToCompanies < ActiveRecord::Migration

  def change
    change_table :companies do |t|
      t.string  :field
      t.text    :office_address
      t.string  :country
      t.text    :description
      t.string  :website
      t.integer :employees_number
      t.integer :employees_registered
    end
  end
end
