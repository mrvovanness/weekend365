module ApplicationHelper
  # Return application title
  def base_title
    'SSS'
  end

  # Return full page title which includes individual page title
  def full_title(page_title)
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
