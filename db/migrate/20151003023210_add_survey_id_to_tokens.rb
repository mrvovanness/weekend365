class AddSurveyIdToTokens < ActiveRecord::Migration
  def change
    change_table :tokens do |t|
      t.belongs_to :company_survey, index: true
    end
  end
end
