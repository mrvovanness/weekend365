class AddColumnToOfferedAnswers < ActiveRecord::Migration
  def change
    change_table :offered_answers do |t|
      t.string :value
      t.string :type
    end
  end
end
