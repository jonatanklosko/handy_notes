require 'rails_helper'

feature "User resets a password" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  given(:user) { create(:user) }
  
  scenario "User clicks 'Forgot password' and follows the instructions" do
    visit signin_path
    click_on 'Forgot password'
    
    fill_in 'Email', with: user.email
    click_on 'Send me reset link'
    
    expect(page).to have_content 'An email with password reset link has been sent'
    open_last_email_for user.email
    click_first_link_in_email
    
    fill_in 'Password', with: 'newpassword'
    fill_in 'Password confirmation', with: 'newpassword'
    click_on 'Update my password'
    
    expect(page).to have_content 'Password has been reseted'
    expect_user_to_be_signed_in
    
    sign_out
    sign_in_with user.username, 'newpassword'
    expect_user_to_be_signed_in
  end
end