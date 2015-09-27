class RemoveStartOnFromCompanySurveys < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :company_surveys do |t|
        dir.up { t.remove :start_on }
        dir.down { t.date :start_on }
      end
    end
  end
end
