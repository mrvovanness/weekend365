class AddOfferedSurveyIdToCompanySurveys < ActiveRecord::Migration
  def change
    change_table :company_surveys do |t|
      t.belongs_to :offered_survey, index: true
    end
  end
end
