class Article < ActiveRecord::Base
  include MarkdownToHTML
  include FriendlyId

  validates :title, :body_markdown, presence: true

  translates :body_html, :body_markdown

  formatted_fields body_html: :body_markdown

  friendly_id :title, use: :slugged
end
