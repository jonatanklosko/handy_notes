module SessionsHelper
  
  # Signs in the given user.
  def sign_in(user)
    session[:user_id] = user.id
  end
  
  # Returns the current user if he is signed in and nil otherwise.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user.correct_token?(:remember, cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the given user is the current one.
  def current_user?(user)
    current_user == user
  end
  
  # Returns true if a user is signed in.
  def signed_in?
    !current_user.nil?
  end
  
  # Rememberes the given user in browser's cookies.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Removes the given user from browser's cookies.
  def forget(user)
    user.forget
    cookies.delete :id
    cookies.delete :remember_token
  end
  
  # Signs out the current user.
  def sign_out
    forget current_user
    session[:user_id] = nil
  end
end
