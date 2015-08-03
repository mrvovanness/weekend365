class RemoveColumnStartDateFromSurveys < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :surveys do |t|
        dir.up { t.remove :start_date }
        dir.down { t.date :start_date }
        dir.up { t.remove :frequency }
        dir.down { t.string :frequency }
      end
    end
  end
end
