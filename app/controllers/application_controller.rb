require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery with: :exception
  before_action :check_user_company
  
  # Don't access admin panel for usual user
  def authenticate_admin_user!
    redirect_to root_path unless user_signed_in? &&
      current_user.has_role?(:admin)
  end

  def check_user_company
    if current_user && current_user.company.nil?
      @company = current_user.build_company
      render 'companies/new', layout: 'home'
    end
  end
end
