class SignupsController < ApplicationController
  layout 'devise'
  def new
    @signup = Signup.new
    if current_user && current_user.has_role?(:admin)
      render layout: 'application'
    end
  end

  def create
    @signup = Signup.new(params[:signup])
    @signup.save
    if current_user && current_user.has_role?(:admin)
      respond_with @signup, location: -> { companies_path }
    else
      respond_with @signup, location: -> { root_path }
    end
  end
end
