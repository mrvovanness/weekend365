class AddTimestampsToCompanySurvees < ActiveRecord::Migration
  def change
  	change_table :company_surveys do |t|
      t.timestamps
    end
  end
end
