class RemoveTypeFromOfferedSurveys < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { remove_column :offered_surveys, :type }
      dir.down { add_column :offered_surveys, :type, :string }
    end
  end
end
