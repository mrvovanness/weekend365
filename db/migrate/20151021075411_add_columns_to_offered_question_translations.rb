class AddColumnsToOfferedQuestionTranslations < ActiveRecord::Migration
  def up
    OfferedQuestion.add_translation_fields!(
      { topic: :string },
      { migrate_data: true }
    )
    OfferedQuestion.add_translation_fields!(
      { subtopic: :string },
      { migrate_data: true }
    )
  end

  def down
    remove_column :offered_question_translations, :topic
    remove_column :offered_question_translations, :subtopic
  end
end
