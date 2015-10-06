class AddOpenQuestionToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :open_question, :string
  end
end
