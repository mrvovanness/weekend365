class RenameOfferedSurveyIdForResults < ActiveRecord::Migration
  def change
    rename_column :results, :offered_survey_id, :company_survey_id
  end
end
