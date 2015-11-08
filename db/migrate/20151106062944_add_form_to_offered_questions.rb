class AddFormToOfferedQuestions < ActiveRecord::Migration
  def change
    add_column :offered_questions, :form_of_answers, :string
  end
end
