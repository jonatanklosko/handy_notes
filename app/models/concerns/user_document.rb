module UserDocument
  extend ActiveSupport::Concern
  
  included do
    # Associations
    belongs_to :user
    
    # Before actions
    before_save :assign_title_when_empty
    before_save :assign_slug, if: :title_changed?
    
    # Validations
    validates :title, length: { maximum: 80 }
  end
  
  
  # Methods
  
  # Overridden in order to use a slug in urls instead of id.
  def to_param
    self.slug
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
      self.slug = "note" if self.slug.empty?
      
      user = User.find_by(id: self.user_id)
      documents = user.send(self.class.name.underscore.pluralize)
      slug_duplicates_count = documents.where('slug LIKE ?', self.slug + '%').count
      
      # Avoid 'new' to be used as a slug (which leads to urls ambiguity)
      self.slug += '-1' if self.slug == "new" && slug_duplicates_count == 0
      
      # If the slug already exists add subsequent number to the ending
      self.slug += "-#{slug_duplicates_count.next}" if slug_duplicates_count > 0
    end
end
