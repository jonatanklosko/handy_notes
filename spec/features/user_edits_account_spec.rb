require 'rails_helper'

feature "User edits his account" do
  
  given(:user) { create(:user) }
  
  before do
    sign_in user
    visit user_settings_path(user)
  end
  
  scenario "with invalid informations" do
    fill_in 'Username', with: ''
    click_on 'Update'
    expect(page).to have_content "Username can't be blank"
    
    fill_in 'Current password', with: user.password
    fill_in 'New password', with: "newone"
    fill_in 'New password confirmation', with: "wrong"
    click_on 'Update password'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
  
  scenario "with valid informations" do
    fill_in 'Username', with: 'NewUsername'
    click_on 'Update'
    expect(page).to have_content "Account updated"
    
    fill_in 'Current password', with: user.password
    fill_in 'New password', with: "newpassword"
    fill_in 'New password confirmation', with: "newpassword"
    click_on 'Update password'
    expect(page).to have_content "Account updated"
    
    sign_out
    sign_in_with 'NewUsername', 'newpassword'
    expect_user_to_be_signed_in
  end
end
