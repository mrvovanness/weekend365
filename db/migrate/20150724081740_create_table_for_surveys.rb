class CreateTableForSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.belongs_to :company, index: true
      t.string :title
      t.string :state
      t.integer :number_of_responses, default: 0
      t.boolean :alarm, default: false
      t.date :start_date
      t.string :frequency
    end
  end
end
