class RemoveOldColumnsFromCompanySurvey < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :company_surveys do |t|
        dir.up { t.remove :finish_on_old }
        dir.down { t.date :finish_on_old }
        dir.up { t.remove :number_of_repeats_old }
        dir.down { t.integer :number_of_repeats_old }
        dir.up { t.remove :repeat_every_old }
        dir.down { t.integer :repeat_every_old }
        dir.up { t.remove :repeat_mode_old }
        dir.down { t.integer :repeat_mode_old }
        dir.up { t.remove :start_at_old }
        dir.down { t.datetime :start_at_old }
        dir.up { t.remove :next_delivery_at_old }
        dir.down { t.datetime :next_delivery_at_old }
      end
    end
  end
end
