class LinksetLink < ActiveRecord::Base
  belongs_to :linkset, touch: true

  # Adds 'http://' to the url prefix if it doesn't already exists.
  def url=(new_url)
    super(new_url)
    unless URI.parse(self.url).scheme
      self.url.prepend("http://")
    end
  end
end
