module Features
  module SessionHelpers
    
        
    def sign_in_with(username, password, options={})
      visit signin_path
      within ".form" do
        fill_in "Username", with: username
        fill_in "Password", with: password
        check 'Remember me' if options[:remember_me]
        click_on "Sign in"
      end
    end
    
    def sign_out
      within("header") { click_link(nil, href: signout_path) }
    end
    
    def expect_user_to_be_signed_in
      expect(page).to have_link(nil, href: signout_path)
    end
    
    def expect_user_to_be_signed_out
      expect(page).to have_link(nil, href: signin_path)
    end
  end
end


RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end
