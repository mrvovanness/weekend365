class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = @company.users.ransack(params[:q])
    @users = @search.result.page(params[:page]).per(15)
  end

  def new
    @user = @company.users.new
  end

  def create
    @user = @company.users.create(user_params)
    respond_with @user
  end

  def edit
    @user = current_user
  end

  def update
    user = current_user
    if user.update(user_params)
      sign_in(user, bypass: true)
      respond_with user, location: -> { surveys_path }
    else
      render :edit
    end
  end

  def destroy_selected
    User.destroy(params[:user_ids])
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
