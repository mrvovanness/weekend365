class CreateAnswersForResults < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :result, index: true
      t.belongs_to :offered_answer, index: true
      t.timestamps null: false
    end
  end
end
