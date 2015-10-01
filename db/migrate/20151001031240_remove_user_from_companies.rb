class RemoveUserFromCompanies < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :companies do |t|
        dir.up { t.remove :user_id }
        dir.down { t.belongs_to :user, index: true }
      end
    end
  end
end
