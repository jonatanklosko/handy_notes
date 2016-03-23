require 'rails_helper'

feature "User manages notes" do
  given(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  scenario "User creates a note" do
    create_note title: "Example note", content: "Example content."
    
    visit root_path
    click_on "Example note"
    expect(page).to have_content "Example note"
    expect(page).to have_content "Example content."
  end
  
  scenario "User edits a note" do
    create_note title: "Example title"
    visit root_path
    click_on "Example title"
    click_on "Edit"
    
    fill_in "note_title", with: "New title"
    fill_in "note_content", with: "New content."
    click_on "Update"
    
    visit root_path
    click_on "New title"
    expect(page).to have_content "New title"
    expect(page).to have_content "New content."
  end
  
  scenario "User deletes a note", js: true do
    create_note title: "Example title"
    visit root_path
    click_on "Example title"
    click_on "Delete"
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    visit root_path
    expect(page).to_not have_content "Example title"
  end
  
  scenario "User deletes a note from his dashboard using ajax", js: true do
    create_note title: "Example note"
    visit root_path
    find('a[data-text*="Example note"][data-method="delete"]').trigger("click")
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    expect(page).to_not have_content "Example note"
  end
end
