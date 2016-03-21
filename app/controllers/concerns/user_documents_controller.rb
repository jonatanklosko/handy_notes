module UserDocumentsController
  extend ActiveSupport::Concern
  
  included do
    before_action :signed_in_user, :correct_user, except: [:show]
    before_action :correct_user_or_shared_page, only: [:show]
    
    before_action :assign_user
    before_action :assign_user_document, except: [:new, :create]
  end
  
  def new
    self.document = user_documents.build
  end
  
  def create
    self.document =  user_documents.build(document_params)
    
    if self.document.save
      redirect_to self.document.path
    else
      flash.now[:error] = self.document.errors.full_messages.first
      render 'new'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if self.document.update_attributes(document_params)
      redirect_to self.document.path
    else
      flash.now[:error] = self.document.errors.full_messages.first
      render 'edit'
    end
  end
  
  def destroy
    self.document.destroy if self.document
    
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { render nothing: true }
    end
  end
  
  protected
    
    # Getter for @<document type>.
    def document
      self.instance_variable_get("@#{controller_name.singularize}")
    end
    
    # Setter for @<document type>.
    def document=(new_document)
      self.instance_variable_set("@#{controller_name.singularize}", new_document)
    end
    
    # Requires the class to have method @<document type>_params.
    def document_params
      self.send("#{controller_name.singularize}_params")
    end
    
    # Reurns all the documents of the type that belongs to @user.
    def user_documents
      @user.send(controller_name)
    end
  
    # Before actions
  
    # Finds the document (that belongs to @user)
    # by slug in params and assigns it to @<document type>.
    def assign_user_document
      self.document = user_documents.find_by(slug: params[:slug])
    end
end
