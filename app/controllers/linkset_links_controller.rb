class LinksetLinksController < ApplicationController
  before_action :signed_in_user, :correct_user, :assign_user, :assign_linkset
  before_action :assign_link, except: [:new, :create]
  
  def new
    @link = @linkset.links.build
    
    respond_to do |format|
      format.js { }
      format.html { redirect_to linkset_path(@user, @linkset) }
    end
  end
  
  def create
    @link = @linkset.links.build(link_params)
    
    if @link.save
      respond_to do |format|
        format.js { }
        format.html { redirect_to @linkset.path }
      end
    end
  end
  
  def edit
    respond_to do |format|
      format.js { }
      format.html { redirect_to @linkset.path }
    end
  end
  
  def update
    if @link.update_attributes(link_params)
      respond_to do |format|
        format.js { }
        format.html { redirect_to @linkset.path }
      end
    end
  end
  
  def destroy
    @link.destroy if @link
    
    respond_to do |format|
      format.js { }
      format.html { redirect_to @linkset.path }
    end
  end
  
  private
  
    def link_params
      params.require(:linkset_link).permit(:name, :url, :description)
    end
  
    # Before actions
  
    # Finds the linkset (that belongs to @user)
    # by slug in params and assigns it to @linkset.
    def assign_linkset
      @linkset = @user.linksets.find_by(slug: params[:linkset_slug])
    end
    
    # Finds the link that belongs to the @linkset by id in params.
    def assign_link
      @link = @linkset.links.find_by(id: params[:id])
    end
end
