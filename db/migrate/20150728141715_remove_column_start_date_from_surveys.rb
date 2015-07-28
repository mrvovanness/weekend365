class RemoveColumnStartDateFromSurveys < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :surveys do |t|
        dir.up { t.remove :start_date }
        dir.down { t.date :start_date }
      end
    end
  end
end
