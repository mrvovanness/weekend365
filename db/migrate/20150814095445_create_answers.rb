class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :mark
      t.belongs_to :question, index: true
      t.timestamps null: false
    end
  end
end
