module UserDocument
  extend ActiveSupport::Concern
  
  # include polymorphic path helper
  include ActionDispatch::Routing::PolymorphicRoutes
  include Rails.application.routes.url_helpers
  
  included do
    # Associations
    belongs_to :user
    
    # Before actions
    before_save :assign_title_when_empty
    before_save :assign_slug, if: :title_changed?
    
    after_create :create_share_url
    after_update :update_share_url, if: :slug_changed?
    before_destroy :remove_share_url
    
    # Validations
    validates :title, length: { maximum: 80 }
  end
  
  
  # Methods
  
  # Overridden in order to use a slug in urls instead of id.
  def to_param
    self.slug
  end
  
  # Returns the path to the document.
  def path
    polymorphic_path(self, username: self.user.username)
  end
  
  # Returns the share url.
  def share_url
    share = Share.find_by(destination_path: self.path)
    Rails.application.routes.url_helpers.share_url share
  end
  
  private
  
    # Before actions
    
    # Assigns 'Untitled' to the title when empty.
    def assign_title_when_empty
      self.title = "Untitled" if self.title.empty?
    end
  
    # Assigns the slug.
    def assign_slug
      # Make a slug based on the title
      self.slug = self.title.parameterize
      
      # Slug is empty when the title contains only non-word characters
      self.slug = "document" if self.slug.empty?
      
      user = User.find_by(id: self.user_id)
      documents = user.send(self.class.name.underscore.pluralize)
      slug_duplicates_count =
                      documents.where('slug ~ ?', "^#{self.slug}(-\d+)?$").count
      
      # Avoid 'new' to be used as a slug (which leads to urls ambiguity)
      self.slug += '-1' if self.slug == "new" && slug_duplicates_count == 0
      
      # If the slug already exists add subsequent number to the ending
      self.slug += "-#{slug_duplicates_count.next}" if slug_duplicates_count > 0
    end
    
    # Add the url to the shares table in the database.
    def create_share_url
      Share.create(destination_path: self.path)
    end
    
    # Update the url in the 'shares' table in the database
    # when slug is changed.
    def update_share_url
      old_path = self.path.gsub(/\/[\w\-]+\z/, "/#{self.slug_was}")
      Share.find_by(destination_path: old_path)
           .update_attribute(:destination_path, self.path)
    end
    
    # Remove the url from the shares table in the database
    # when the document is removed.
    def remove_share_url
      Share.find_by(destination_path: self.path).destroy
    end
end
