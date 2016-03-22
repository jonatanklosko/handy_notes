module UserDocumentsHelper
  
  # Returns true if a user is signed in and a username in params
  # belongs to the signed in user.
  def signed_in_as_owner?
    signed_in? && params[:username] == current_user.username
  end
end
