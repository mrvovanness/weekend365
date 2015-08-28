class CreateOfferedSurveys < ActiveRecord::Migration
  def change
    create_table :offered_surveys do |t|
      t.string :title
      t.string :type

      t.timestamps null: false
    end
  end
end
