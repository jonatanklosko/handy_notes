require 'rails_helper'

feature "User shares documents" do
  given(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  scenario "User goes to the note and clicks 'Share'", js: true do
    create_note title: "New note", content: "Content of the note."
    visit root_path
    click_on "New note"
    click_on "Share"
    # Copy the link
    share_link = find('.sweet-alert input').value
    share_path = share_link[/\/shares\/.+/]
    # Leave the message box
    click_on "OK"
    
    # Simulate getting the link as signed out user somewhere else
    sign_out
    
    visit share_path
    
    expect(page).to have_content "New note"
    expect(page).to have_content "Content of the note."
    expect(page).to_not have_selector ".actions"
  end
end