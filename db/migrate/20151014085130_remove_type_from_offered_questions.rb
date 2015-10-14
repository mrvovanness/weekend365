class RemoveTypeFromOfferedQuestions < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { remove_column :offered_answers, :type }
      dir.down { add_column :offered_answers, :type, :string }
    end
  end
end
