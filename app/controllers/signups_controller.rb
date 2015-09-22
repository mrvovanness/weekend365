class SignupsController < ApplicationController
  layout 'devise'
  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(params[:signup])
    if @signup.save
      respond_with @signup, location: -> { root_path }
    else
      render :new
    end
  end
end
