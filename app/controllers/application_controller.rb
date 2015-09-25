require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :set_locale

  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery with: :exception

  # Don't access admin panel for usual user
  def authenticate_admin_user!
    redirect_to root_path unless user_signed_in? &&
      current_user.has_role?(:admin)
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
      current_user.update(locale: locale.to_sym) if params[:locale]
      session[:locale] = I18n.locale = locale.to_sym
    end
  end
end
