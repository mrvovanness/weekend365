class AddDescriptionToOfferedSurveyTranslations < ActiveRecord::Migration
  def up
    OfferedSurvey.add_translation_fields! description: :string
  end

  def down
    remove_column :offered_survey_translations, :description
  end
end
