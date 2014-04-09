class Admin::UsersController < ApplicationController
  respond_to :html

  require_admin

  before_action :set_user, except: [:index, :new, :create]

  def index
    @users = User.all
    respond_with :admin, @users
  end

  def new
    @user = User.new
    respond_with :admin, @user
  end

  def create
    password_confirmation = user_params[:password]

    @user = User.create user_params
      .merge password_confirmation: password_confirmation

    respond_with :admin, @user, location: admin_users_path
  end

  def edit
    respond_with :admin, @user
  end

  def update
    @user.update_attributes user_params
    @user.save

    respond_with :admin, @user, location: admin_users_path
  end

  def destroy
    @user.destroy
    respond_with :admin, @user, location: admin_users_path
  end

  private
  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end
end
