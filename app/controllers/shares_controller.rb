class SharesController < ApplicationController
  
  def show
    share = Share.find_by(token: params[:share_token])
    if share
      session[share.destination_path] = "shared"
      redirect_to share.destination_path
    else
      flash[:error] = "Invalid share link."
      redirect_to root_url
    end
  end
end
