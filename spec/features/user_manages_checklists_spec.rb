require 'rails_helper'

feature "User manages checklists" do
  given(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  scenario "User creates a chcklist", js: true do
    create_checklist title: "Example checklist",
                     items: ["Foo", "Bar", "Baz"]
    
    expect(page).to have_content "Example checklist"
    expect_page_to_have_items "Foo", "Bar", "Baz"
  end
  
  scenario "User edits a checklist", js: true do
    create_checklist title: "Example checklist",
                     items: ["Foo", "Bar", "Baz"]
    click_on "Edit"
    
    fill_in "checklist_title", with: "New title"
    edit_item "Foo", with: "Edited foo"
    edit_item "Bar", with: ""
    enter_new_items "New foo", "New bar"
    click_on "Save"
    
    visit root_path
    click_on "New title"
    expect(page).to have_content "New title"
    expect_page_to_have_items "Edited foo", "Baz", "New foo", "New bar"
    expect_page_to_not_have_items "Bar"
  end
  
  scenario "User marks items as checked and unchecked", js: true do
    create_checklist title: "Example checklist",
                     items: ["Foo", "Bar", "Baz"]
    
    click_items "Foo", "Baz"
    sign_out_in_and_visit_checklist "Example checklist"
    expect_items_to_be :checked, "Foo", "Baz"
    expect_items_to_be :unchecked, "Bar"
    
    click_items "Foo", "Bar"
    sign_out_in_and_visit_checklist "Example checklist"
    expect_items_to_be :checked, "Bar", "Baz"
    expect_items_to_be :unchecked, "Foo"
  end
  
  scenario "User deletes a checklist", js: true do
    create_checklist title: "Example checklist"
    visit root_path
    click_on "Example checklist"
    click_on "Delete"
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    visit root_path
    expect(page).to_not have_content "Example checklist"
  end
  
  scenario "User deletes a checklist from his dashboard using ajax", js: true do
    create_checklist title: "Example checklist"
    visit root_path
    find('a[data-text*="Example checklist"][data-method="delete"]')
                                                  .trigger("click")
    # Confirm (wait for message box to appear)
    sleep 0.5
    click_on "Yes"
    
    expect(page).to_not have_content "Example checklist"
  end
  
  private
    
    def enter_new_items(*items)
      items.each do |item|
        find(".items input:last-child").set item
      end
    end
    
    def edit_item(item, with:)
      find("input[value=\"#{item}\"]").set with
    end
    
    def expect_page_to_have_items(*items)
      items.each { |item| expect(page).to have_content item }
    end
    
    def expect_page_to_not_have_items(*items)
      items.each { |item| expect(page).to_not have_content item }
    end
    
    def click_items(*items)
      items.each { |item| find("label", text: item).click }
    end
    
    def expect_items_to_be(state, *items)
      items.each do |item|
        label = find("label", text: item)
        checkbox = find_by_id(label[:for], visible: false)
        expect(checkbox).send(state == :checked ? 'to' : 'to_not',
                              be_checked)
      end
    end
    
    def sign_out_in_and_visit_checklist(title)
      sign_out
      sign_in user
      visit root_path
      click_on title
    end
end
