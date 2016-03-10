class NotesController < ApplicationController
  before_action :signed_in_user, :correct_user, :assign_user
  before_action :assign_note, only: [:show, :edit, :update, :destroy]
  
  def new
    @note = @user.notes.build
  end
  
  def create
    @note = @user.notes.build(note_params)
    
    if @note.save
      redirect_to note_url(current_user, @note)
    else
      flash.now[:error] = @note.errors.full_messages.first
      render 'new'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @note.update_attributes(note_params)
      redirect_to note_url(@user, @note)
    else
      flash.now[:error] = @note.errors.full_messages.first
      render 'edit'
    end
  end
  
  def destroy
    @note.destroy if @note
    flash[:success] = "'#{@note.title}' has been deleted."
    redirect_to root_url
  end
  
  private
  
    def note_params
      params.require(:note).permit(:title, :content)
    end
    
    # Before actions
    
    # Finds the user by username in params and assigns it to @user.
    def assign_user
      @user = User.find_by(username: params[:username])
    end
    
    # Finds the note by slug in params and assigns it to @note.
    def assign_note
      @note = @user.notes.find_by(slug: params[:slug])
    end
end
