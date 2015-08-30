class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :offered_question, index: true
      t.belongs_to :offered_survey, index: true

      t.timestamps null: false
    end
  end
end
