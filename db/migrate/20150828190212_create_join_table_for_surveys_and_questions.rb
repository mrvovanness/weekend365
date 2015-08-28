class CreateJoinTableForSurveysAndQuestions < ActiveRecord::Migration
  def change
    create_table :company_surveys_offered_questions, id: false do |t|
      t.belongs_to :company_survey, index: true
      t.belongs_to :offered_question, index: true
    end
  end
end
