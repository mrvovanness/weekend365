class AddTranslationsForOfferedSurveys < ActiveRecord::Migration
  def self.up
    OfferedSurvey.create_translation_table!({
      title: :string
    }, {
      migrate_data: true
    })
  end

  def self.down
    OfferedSurvey.drop_translation_table! migrate_data: true
  end
end
