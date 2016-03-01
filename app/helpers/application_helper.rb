module ApplicationHelper
  include FontAwesome::Sass::Rails::ViewHelpers
  
  # Returns title optionally containing the given subtitle.
  def full_title(page_title = "")
    base_title = "Handy Notes"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end
end
