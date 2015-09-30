require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_company

  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if (current_user.updated_at - current_user.confirmed_at) <= 1
      current_user.touch
      edit_company_path(current_user.company)
    else
      dashboard_index_path
    end
  end

  private

  def set_locale
    locale = case
             when params[:locale] then params[:locale]
             when current_user then current_user.locale
             when session[:locale] then session[:locale]
             else
               http_accept_language.compatible_language_from(I18n.available_locales)
             end

    if locale && I18n.available_locales.include?(locale.to_sym)
      current_user.update(locale: locale.to_sym) if current_user && params[:locale]
      session[:locale] = I18n.locale = locale.to_sym
    end
  end

  def set_company
    if user_signed_in?
      if current_user.is_admin? && session[:current_company]
        @company = Company.find(session[:current_company])
      else
        @company = current_user.company
      end
    end
  end
end
