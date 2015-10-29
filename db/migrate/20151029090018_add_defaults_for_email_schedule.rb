class AddDefaultsForEmailSchedule < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { change_column_default :email_schedules, :repeat_every, 1 }
      dir.down { change_column_default :email_schedules, :repeat_every, nil }
      dir.up { change_column_default :email_schedules, :repeat_mode,  'w' }
      dir.down { change_column_default :email_schedules, :repeat_mode,  nil }
      dir.up { change_column_default :email_schedules, :number_of_repeats,  1 }
      dir.down { change_column_default :email_schedules, :number_of_repeats,  nil }
    end
  end
end

