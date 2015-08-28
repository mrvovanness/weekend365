class CreateSqaAssignments < ActiveRecord::Migration
  def change
    create_table :sqa_assignments do |t|
      t.belongs_to :offered_survey, index: true
      t.belongs_to :offered_question, index: true
      t.belongs_to :offered_answer, index: true

      t.timestamps null: false
    end
  end
end
