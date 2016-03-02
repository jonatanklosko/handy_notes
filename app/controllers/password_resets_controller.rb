class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
                                        only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user
      @user.send_password_reset_email
      flash[:info] = "An email with password reset link has been sent."
      redirect_to root_url
    else
      flash.now[:error] = "Can't find that email, sorry."
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
    elsif @user.update_attributes(user_params)
      sign_in @user
      flash[:success] = "Password has been reseted."
      redirect_to root_url
    else
      render 'edit'
    end
  end
  
  private
  
    # Before filters
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def valid_user
      unless @user && @user.correct_token?(:reset, params[:id])
        flash[:error] = "Invalid reset link."
        redirect_to root_url
      end
      
      unless @user.activated?
        flash[:error] = "You haven't activated your account yet."
        redirect_to root_url
      end
    end
    
    def check_expiration
      if @user.password_reset_expired?
        flash[:error] = "The reset link has expired."
        redirect_to root_url
      end
    end
end
