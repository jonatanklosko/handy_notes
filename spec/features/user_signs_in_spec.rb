require 'rails_helper'

feature "User signs in" do
  include ShowMeTheCookies
  
  scenario "with valid username and password" do
    create_user 'sherlock', 'password'
    sign_in_with 'sherlock', 'password'
    
    expect_user_to_be_signed_in
    expect(page).to have_content "Welcome back sherlock"
  end
  
  scenario "with invalid password" do
    create_user 'sherlock', 'password'
    sign_in_with 'sherlock', 'wrong_password'
    
    expect_page_to_display_sign_in_error
    expect_user_to_be_signed_out
  end
  
  scenario "with invalid username" do
    create_user 'sherlock', 'password'
    sign_in_with 'holmes', 'password'
    
    expect_page_to_display_sign_in_error
    expect_user_to_be_signed_out
  end
  
  scenario "as unactivated user" do
    create(:user, username: 'sherlock', password: 'password',
                  activated_at: nil)
    sign_in_with 'sherlock', 'password'
    
    expect_page_to_display_activation_error
    expect_user_to_be_signed_out
  end
  
  scenario "with 'remember me' checked" do
    create_user 'sherlock', 'password'
    sign_in_with 'sherlock', 'password', remember: true
    
    expect_user_to_be_signed_in
    expire_cookies # simulate browser restart (remove session cookies)
    visit root_path
    expect_user_to_be_signed_in
  end
  
  private
  
    def create_user(username, password)
      create(:user, username: username, password: password)
    end
    
    def expect_page_to_display_sign_in_error
      expect(page).to have_content "Invalid username/password combination"
    end
    
    def expect_page_to_display_activation_error
      expect(page).to have_content "You haven't activated your account yet"
    end
end