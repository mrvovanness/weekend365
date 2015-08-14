class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :name
      t.boolean :expired
      t.timestamps null: false
    end
  end
end
