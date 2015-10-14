class RemoveTypeFromOfferedAnswers < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { remove_column :offered_questions, :type }
      dir.down { add_column :offered_questions, :type, :string }
    end
  end
end
