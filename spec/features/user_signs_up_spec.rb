require 'rails_helper'

feature "User signs up" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  scenario "with valid informations" do
    sign_up_with email: "sholmes@example.com"
    expect(page).to have_content "An activation link has been sent"
    expect_user_to_be_signed_out

    open_last_email_for "sholmes@example.com"
    click_first_link_in_email
    expect(page).to have_content "Your account has been activated!"
    expect_user_to_be_signed_in
  end
  
  scenario "with blank name" do
    sign_up_with username: ' '
    expect(page).to have_content "Username can't be blank"
  end
  
  scenario "with too short name" do
    sign_up_with username: 'foo'
    expect(page).to have_content "Username is too short"
  end
  
  scenario "with invalid email" do
    sign_up_with email: 'sholmes.com'
    expect(page).to have_content "Email is invalid"
  end
  
  scenario "with empty password" do
    sign_up_with password: ''
    expect(page).to have_content "Password can't be blank"
  end
  
  scenario "with wrong password confirmation" do
    sign_up_with password_confirmation: 'definitely wrong'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
  
  scenario "with username that has already been taken" do
    create(:user, username: "sherlock")
    sign_up_with username: "sherlock"
    expect(page).to have_content 'Username has already been taken'
  end
  
  scenario "with email that has already been taken" do
    create(:user, email: "sholmes@example.com")
    sign_up_with email: "sholmes@example.com"
    expect(page).to have_content 'Email has already been taken'
  end
  
  private
  
    def sign_up_with(user_params = {})
      user = build(:user, user_params)
      visit signup_path
      fill_in 'Username', with: user.username
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_on 'Sign up'
    end
end
