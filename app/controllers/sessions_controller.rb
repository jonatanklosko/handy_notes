class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by(username: params[:user][:username])
    
    if @user && @user.authenticate(params[:user][:password])
      if @user.activated?
        remember @user if params[:user][:remember] == "1"
        sign_in @user
        flash[:success] = "Welcome back #{@user.username}"
        redirect_to root_url
      else
        flash[:warning] = "You haven't activated your account yet. Please check your mailbox."
        render 'new'
      end
    else
      flash.now[:error] = "Invalid username/password combination"
      render 'new'
    end
  end
  
  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end
end
