class RenameSurveyIdInJoinTable < ActiveRecord::Migration
  def change
    rename_column :company_surveys_employees, :survey_id, :company_survey_id
  end
end
