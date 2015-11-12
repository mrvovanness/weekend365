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

  # Return current url
  def current_url(new_params)
    url_for :params => params.merge(new_params)
  end

  def distribution_to_scale(distr_hash)
    if distr_hash.values.sum == 0
      return content_tag(:span, t('report.show.no_data'), class: 'black')
    end
    tooltips = [
      t('tooltips.strongly_disagree'),
      t('tooltips.disagree'),
      t('tooltips.neither'),
      t('tooltips.agree'),
      t('tooltips.strongly_agree')
    ]
    widths = distr_hash.values.map do |w|
      number_to_percentage(w.to_f / distr_hash.values.sum * 100, precision: 0)
    end
    distr_hash.delete_if { |key, value| value == 0 }
    content_tag :table do
      content_tag :tr do
        distr_hash.keys.collect do |key|
          content_tag(:td, class: "color#{key}", style: "width: #{widths[key-1]}") do
            concat widths[key-1]
            concat content_tag(:span, tooltips[key-1], class: 'tooltip')
          end
        end.join.html_safe
      end
    end
  end

  def add_tooltip(value)
    tooltips = {
      1 => t('tooltips.strongly_disagree'),
      2 => t('tooltips.disagree'),
      3 => t('tooltips.neither'),
      4 => t('tooltips.agree'),
      5 => t('tooltips.strongly_agree')
    }
    content_tag(:span, tooltips[value], class: 'tooltip')
  end

  def value_to_row(value)
    tooltips = [
      t('tooltips.strongly_disagree'),
      t('tooltips.disagree'),
      t('tooltips.neither'),
      t('tooltips.agree'),
      t('tooltips.strongly_agree')
    ]
    tooltips[value-1]
  end
end
