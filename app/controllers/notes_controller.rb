class NotesController < ApplicationController
  before_action :assign_note, only: [:show, :edit, :update, :delete]
  
  def new
    @note = current_user.notes.build
  end
  
  def create
    @note = current_user.notes.build(note_params)
    
    if @note.save
      redirect_to note_url(current_user, @note)
    else
      flash.now[:error] = @note.errors.full_messages.first
      render 'new'
    end
  end
  
  def show
  end
  
  private
  
    def note_params
      params.require(:note).permit(:title, :content)
    end
    
    # Before actions
    
    # Finds the note by slug in params and assigns it to @note.
    def assign_note
      @note = current_user.notes.find_by(slug: params[:slug])
    end
end
