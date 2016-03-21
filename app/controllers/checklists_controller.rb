class ChecklistsController < ApplicationController
  include UserDocumentsController
  
  def new
    @checklist = @user.checklists.build
    @new_items = {}
  end
  
  def create
    @checklist = @user.checklists.build(checklist_params)
    @new_items = params.fetch(:new_items, {})
                 .select { |_, description| description.present? }
                 
    if @checklist.save
      # Create new items
      @new_items.each do |_, description|
        @checklist.items.create(description: description) if description.present?
      end
      
      redirect_to checklist_url(@user, @checklist)
    else
      flash.now[:error] = @checklist.errors.full_messages.first
      render 'new'
    end
  end
  
  def edit
    @new_items = {}
    @existing_items = @checklist.items
  end
  
  def update
    @new_items = params.fetch(:new_items, {})
                 .select { |_, description| description.present? }
    
    @existing_items = params.fetch(:existing_items, {}).map do |id, description|
      @checklist.items.find_by(id: id).tap do |item|
        item.description = description
      end
    end
    
    if @checklist.update_attributes(checklist_params)
      # Update modified items
      @existing_items.each(&:save)
      
      # Remove items with empty description
      # (which does not appear in params[:existing_items])
      (@checklist.items - @existing_items).each(&:destroy)
      
      # Create new items
      @new_items.each do |_, description|
        @checklist.items.create(description: description)
      end
      
      redirect_to checklist_url(@user, @checklist)
    else
      flash.now[:error] = @checklist.errors.full_messages.first
      render 'edit'
    end
  end
  
  def toggle_item
    item = @checklist.items.find_by id: params[:item_id]
    item.toggle! :checked
    
    render nothing: true
  end
  
  private
  
    def checklist_params
      params.require(:checklist).permit(:title)
    end
end
