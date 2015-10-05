class AddSlugToArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.string :slug, null: false
      t.index :slug
    end
  end
end
