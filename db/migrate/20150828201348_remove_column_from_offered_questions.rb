class RemoveColumnFromOfferedQuestions < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :offered_questions do |t|
        dir.up { t.remove :survey_id }
        dir.down { t.belongs_to :survey, index: true }
      end
    end
  end
end
