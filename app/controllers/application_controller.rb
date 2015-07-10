class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Don't access admin panel for usual user
  def authenticate_admin_user!
    redirect_to root_path unless current_user.has_role? :admin
  end
end
