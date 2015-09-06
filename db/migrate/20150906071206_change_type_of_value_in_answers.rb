class ChangeTypeOfValueInAnswers < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { change_column :offered_answers, :value, 'integer USING CAST(value AS integer)' }
      dir.down { change_column :offered_answers, :value, 'varchar(40) USING CAST(value AS varchar(40))' }
    end
  end
end
