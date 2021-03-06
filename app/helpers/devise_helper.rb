module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map do |msg|
      content_tag(:li, msg)
    end.join

    html = <<-HTML
    <div class="alert alert-error alert-danger">
    <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
