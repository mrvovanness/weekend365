class ChangeTableNameOfQuestions < ActiveRecord::Migration
  def change
    rename_table :questions, :offered_questions
  end
end
