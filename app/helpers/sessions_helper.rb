module SessionsHelper
  
  # Signs in the given user.
  def sign_in(user)
    session[:user_id] = user.id
  end
  
  # Returns the current user if he is signed in and nil otherwise.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # Returns true if the given user is the current one.
  def current_user?(user)
    current_user == user
  end
  
  # Returns true if a user is signed in.
  def signed_in?
    !current_user.nil?
  end
  
  # Signs out the current user.
  def sign_out
    session[:user_id] = nil
  end
end
