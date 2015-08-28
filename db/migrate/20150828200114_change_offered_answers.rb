class ChangeOfferedAnswers < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :offered_answers do |t|
        dir.up { t.remove :mark }
        dir.down { t.integer :mark }
        dir.up { t.remove :question_id }
        dir.down { t.belongs_to :question, index: true }
      end
    end
  end
end
