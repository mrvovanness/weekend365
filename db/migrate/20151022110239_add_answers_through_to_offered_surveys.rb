class AddAnswersThroughToOfferedSurveys < ActiveRecord::Migration
  def change
    add_column :offered_surveys, :answers_through, :string
  end
end
