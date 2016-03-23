require 'rails_helper'

feature "User manages linksets" do
  given(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  scenario "User creates a linkset" do
    create_linkset title: "My linkset"
    visit root_path
    click_on "My linkset"
    expect(page).to have_content "My linkset"
  end
  
  scenario "User edits a linkset" do
    create_linkset title: "My linkset"
    visit root_path
    click_on "My linkset"
    click_on "Edit"
    fill_in "linkset_title", with: "New title"
    click_on "Update"
    expect(page).to have_content "New title"
  end
    
  scenario "User deletes a linkset", js: true do
    create_linkset title: "My linkset"
    visit root_path
    click_on "My linkset"
    click_on "Delete"
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    visit root_path
    expect(page).to_not have_content "My linkset"
  end
  
  scenario "User deletes a linkset from his dashboard using ajax", js: true do
    create_linkset title: "My linkset"
    visit root_path
    find('a[data-text*="My linkset"][data-method="delete"]').trigger("click")
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    expect(page).to_not have_content "My linkset"
  end
  
  scenario "User adds a link to the linkset", js: true do
    create_linkset title: "My linkset"
    visit root_path
    click_on "My linkset"
    add_link name: "First link", url: "google.com", description: "Description"
    expect(page).to have_content "Description"
    
    new_window =  window_opened_by { click_on "First link" }
    within_window new_window do
      expect(current_url).to include "google.com"
    end
  end
  
  scenario "User edits a link within linkset", js: true do
    create_linkset title: "My linkset"
    visit root_path
    click_on "My linkset"
    add_link name: "Link name", description: "Link description"
    
    within(".link") { find('a[href*="edit"]').trigger "click" }
    fill_in "linkset_link_name", with: "New link name"
    fill_in "linkset_link_description", with: "New link description"
    click_on "Save"
    
    expect(page).to have_content "New link name"
    expect(page).to have_content "New link description"
  end
  
  scenario "User removes a link from linkset", js: true do
    create_linkset title: "My linkset"
    visit root_path
    click_on "My linkset"
    add_link name: "My favourite link", description: "My link description"
    
    within(".link") { find('a[data-method="delete"]').trigger "click" }
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    expect(page).to_not have_content "My favourite link"
    expect(page).to_not have_content "My link description"
  end
  
  private
  
    def create_linkset(title: "Title")
      visit root_path
      click_on "Linkset"
      fill_in "linkset_title", with: title
      click_on "Create"
    end
    
    def add_link(name: "Google", url: "google.com", description: "Google.")
      find(".description", text: "Add a new link").click
      fill_in "linkset_link_name", with: name
      fill_in "linkset_link_url", with: url
      fill_in "linkset_link_description", with: description
      click_on "Add"
    end
end
