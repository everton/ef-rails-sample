# -*- coding: utf-8 -*-

class SessionsController < ApplicationController
  skip_before_action :save_return_path

  def new
    @user = User.new
  end

  def create
    @user = User.where(email: params[:email]).first

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id

      flash.notice = 'Welcome!'
      redirect_to session[:return_path] || root_url
    else
      flash.alert = 'Invalid password or username'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
