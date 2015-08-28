class ChangeTableNameOfAnswers < ActiveRecord::Migration
  def change
    rename_table :answers, :offered_answers
  end
end
