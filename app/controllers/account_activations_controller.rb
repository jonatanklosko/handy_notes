class AccountActivationsController < ApplicationController
  
  def show
    @user = User.find_by(email: params[:email])
    if @user && !@user.activated? && @user.correct_token?(:activation, params[:id])
      @user.activate
      sign_in @user
      flash[:success] = "Your account has been activated!"
      redirect_to root_url
    else
      flash[:error] = "Invalid activation link."
      redirect_to root_url
    end
  end
end
