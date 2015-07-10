class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Don't access admin panel for usual user
  def authenticate_admin_user!
<<<<<<< HEAD
    redirect_to root_path unless current_user.has_role? :admin
=======
    redirect_to root_path unless user_signed_in? && current_user.has_role?(:admin)
>>>>>>> new_admin_panel
  end
end
