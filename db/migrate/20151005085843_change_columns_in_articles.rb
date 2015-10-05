class ChangeColumnsInArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.rename :body, :body_html
      t.text :body_markdown
    end

    change_table :article_translations do |t|
      t.rename :body, :body_html
      t.text :body_markdown
    end
  end
end
