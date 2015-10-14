class AddColumnsToOfferedQuestions < ActiveRecord::Migration
  def change
    change_table :offered_questions do |t|
      t.string :topic
      t.string :subtopic
    end
  end
end
