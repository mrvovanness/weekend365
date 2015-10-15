class CreateEmailSchedules < ActiveRecord::Migration
  def change
    create_table :email_schedules do |t|
      t.datetime :start_at
      t.date :finish_on
      t.integer :number_of_repeats
      t.integer :repeat_every
      t.string :repeat_mode
      t.datetime :next_delivery_at
      t.belongs_to :company_survey, index: true

      t.timestamps null: false
    end
  end
end
