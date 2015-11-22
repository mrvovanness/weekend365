class CreateOfficeLocations < ActiveRecord::Migration
  def change
    create_table :office_locations do |t|
      t.string  :country
      t.string  :city
      t.text    :address
      t.references :company
      t.timestamps null: false
    end
  end
end
