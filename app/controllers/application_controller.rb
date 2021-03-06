require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_company
  around_action :set_time_zone

  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if (current_user.updated_at - current_user.confirmed_at) <= 1
      current_user.touch
      if current_user.is_admin_for?(current_user.company)
        edit_company_path(current_user.company)
      else
        surveys_path
      end
    else
      surveys_path
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
      if current_user && params[:locale]
        current_user.update_attribute(:locale, locale.to_sym)
      end
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

  def set_time_zone
    if user_signed_in? && current_user.company.try(:timezone)
      user_time_zone = ActiveSupport::TimeZone[current_user.company.timezone]
      Time.use_zone(user_time_zone) { yield }
    else
      yield
    end
  end
end
