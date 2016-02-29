class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by(username: params[:user][:username])
    
    if @user && @user.authenticate(params[:user][:password])
      sign_in @user
      flash[:success] = "Welcome back #{@user.username}"
      redirect_to root_url
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
