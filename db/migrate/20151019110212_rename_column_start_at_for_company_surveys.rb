class RenameColumnStartAtForCompanySurveys < ActiveRecord::Migration
  def change
    change_table :company_surveys do |t|
      t.rename :start_at, :start_at_old
      t.rename :finish_on, :finish_on_old
      t.rename :number_of_repeats, :number_of_repeats_old
      t.rename :repeat_mode, :repeat_mode_old
      t.rename :repeat_every, :repeat_every_old
      t.rename :next_delivery_at, :next_delivery_at_old
    end
  end
end
