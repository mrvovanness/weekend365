require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery with: :exception

  # Don't access admin panel for usual user
  def authenticate_admin_user!
    redirect_to root_path unless user_signed_in? &&
      current_user.has_role?(:admin)
  end
end
