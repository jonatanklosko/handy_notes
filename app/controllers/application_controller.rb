class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
    # Before filters
  
    # Requires a user to be signed in.
    def signed_in_user
      redirect_to signin_url unless signed_in?
    end
end
