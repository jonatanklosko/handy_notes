class LinksetsController < ApplicationController
  include UserDocumentsController
  
  private
  
    def linkset_params
      params.require(:linkset).permit(:title)
    end
end
