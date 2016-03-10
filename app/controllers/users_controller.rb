class UsersController < ApplicationController
  before_action :signed_in_user, :find_user, :correct_user,
                only: [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:info] = "An activation link has been sent. Please check your mailbox."
      @user.send_activation_email
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def show
    @documents = @user.notes.order(updated_at: :desc) # temporary
       # TODO: add method to users returning all kind of documents in correct order
  end
  
  def edit
  end
  
  def update
    case params[:update_section]
    when "general"
    when "password"
      if !@user.authenticate(params[:user][:current_password])
        @user.errors.add :current_password, "is incorrect"
      elsif params[:user][:password].empty?
        @user.errors.add :password, "can't be empty"
      end
    else
      redirect_to root_url
    end
    
    if @user.errors.empty? && @user.update_attributes(user_params)
      flash.now[:success] = "Account updated."
      params[:username] = @user.username
    end
    render 'edit'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:username, :email,
                                   :password, :password_confirmation)
    end
    
    # Before filters
    
    def find_user
      @user = User.find_by(username: params[:username])
      redirect_to root_url unless @user
    end
end
