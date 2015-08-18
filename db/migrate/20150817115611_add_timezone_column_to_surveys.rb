class AddTimezoneColumnToSurveys < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :surveys do |t|
        dir.up { t.remove :start_at }
        dir.down { t.time :start_at }
      end
    end
  end
end
