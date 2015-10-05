require 'redcarpet'

module MarkdownToHTML
  extend ActiveSupport::Concern

  module ClassMethods
    def formatted_fields(fields)
      fields.each do |html, markdown|
        define_method "#{markdown}=" do |markdown_text|
          write_attribute(markdown, markdown_text)
          write_attribute(html, markdown_to_html(markdown_text))
        end
      end
    end
  end

  def markdown_to_html(markdown)
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    redcarpet.render(markdown)
  end
end
