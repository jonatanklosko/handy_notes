module Features
  module UserDocumentsHelpers
  
    def create_note(title: "Example note", content: "Example content.")
      visit root_path
      within("#toolkit") { click_on "Note" }
      
      fill_in "note_title", with: title
      fill_in "note_content", with: content
      click_on "Create"
    end
  
    def create_checklist(title: "Example checklist",
                         items: ["First", "Second", "Third"])
      visit root_path
      within("#toolkit") { click_on "Checklist" }
      
      fill_in "checklist_title", with: title
      enter_new_items(*items)
      click_on "Create"
    end
  end
end


RSpec.configure do |config|
  config.include Features::UserDocumentsHelpers, type: :feature
end
