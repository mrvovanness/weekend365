class AddBaseForCorrelationToOfferedQuestion < ActiveRecord::Migration
  def change
    change_table :offered_questions do |t|
      t.boolean :base_for_correlation, default: false
    end
  end
end
