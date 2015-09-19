class AddTranslationsForOfferedQuestions < ActiveRecord::Migration
  def self.up
    OfferedQuestion.create_translation_table!({
      title: :string
    }, {
      migrate_data: true
    })
  end

  def self.down
    OfferedQuestion.drop_translation_table! migrate_data: true
  end
end
