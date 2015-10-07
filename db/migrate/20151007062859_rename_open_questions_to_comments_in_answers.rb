class RenameOpenQuestionsToCommentsInAnswers < ActiveRecord::Migration
  def change
    rename_column :answers, :open_question, :comment
  end
end
