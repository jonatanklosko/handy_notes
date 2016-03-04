module Controllers
  module SessionHelpers
    
    def sign_in(user)
      session[:user_id] = user.id
    end
    
    def sign_out
      session[:user_id] = nil
    end
  end
end


RSpec.configure do |config|
  config.include Controllers::SessionHelpers, type: :controller
end
