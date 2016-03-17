class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  private
  
    # Before filters
  
    # Requires a user to be signed in.
    def signed_in_user
      if signed_in?
        return true
      else
        redirect_to signin_url and return false
      end
    end
    
    # Requires the current user to be the same one
    # for which the action is performed.
    def correct_user
      redirect_to root_url if params[:username] != current_user.username
    end
    
    # Finds the user by username in params and assigns it to @user.
    def assign_user
      @user = User.find_by(username: params[:username])
    end
    
    # Requires session[request.path] to be set to 'shared' or a user
    # to be signed in as same one for which the action is performed.
    def correct_user_or_shared_page
      if session[request.path] != "shared"
        # Run normal callbacks
        signed_in_user && correct_user
      end
    end
end
