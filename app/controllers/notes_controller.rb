class NotesController < ApplicationController
  include UserDocumentsController
  
  private
  
    def note_params
      params.require(:note).permit(:title, :content)
    end
end
