class AddAddedByUserToOfferedQuestions < ActiveRecord::Migration
  def change
    change_table :offered_questions do |t|
      t.boolean :added_by_user, default: false
    end
  end
end
