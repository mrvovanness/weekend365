module ApplicationHelper
  # Return application title
  def base_title
    'Weekend'
  end

  # Return full page title which includes individual page title
  def full_title(page_title)
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # Create navigation link.
  # If link is a current page, method adds 'active' class to wrapper li element
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end
end
