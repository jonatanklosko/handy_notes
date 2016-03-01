require 'rails_helper'

feature "User signs in" do
  
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
    create_user 'sherlock', 'password', activated: false
    sign_in_with 'sherlock', 'password'
    
    expect_page_to_display_activation_error
    expect_user_to_be_signed_out
  end
  
  private
  
    def create_user(username, password, options={activated: true})
      activated_at = options[:activated] ? Time.now : nil
      create(:user, username: username, password: password,
                    activated_at: activated_at)
    end
    
    def sign_in_with(username, password)
      visit signin_path
      within ".form" do
        fill_in "Username", with: username
        fill_in "Password", with: password
        click_on "Sign in"
      end
    end
  
    def expect_user_to_be_signed_in
      expect(page).to have_link(nil, href: signout_path)
    end
    
    def expect_user_to_be_signed_out
      expect(page).to have_link(nil, href: signin_path)
    end
    
    def expect_page_to_display_sign_in_error
      expect(page).to have_content "Invalid username/password combination"
    end
    
    def expect_page_to_display_activation_error
      expect(page).to have_content "You haven't activated your account yet"
    end
end