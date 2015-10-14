class AddDescriptionToOfferedSurveys < ActiveRecord::Migration
  def change
    add_column :offered_surveys, :description, :string
  end
end
