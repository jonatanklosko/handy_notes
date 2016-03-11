module ApplicationHelper
  include FontAwesome::Sass::Rails::ViewHelpers
  
  # Returns title optionally containing the given subtitle.
  def full_title(page_title = "")
    base_title = "Handy Notes"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end
  
  # Returns the given text as html made with markdown.
  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: {rel: 'nofollow', target: "_blank"}
    }
    
    extensions = {
      autolink: true,
      superscript: true,
      no_intra_emphasis: true,
      footnotes: true,
      tables: true
    }
    
    @@renderer ||= Redcarpet::Render::HTML.new(options)
    @@markdown ||= Redcarpet::Markdown.new(@@renderer, extensions)
    
    @@markdown.render(text).html_safe
  end
end
