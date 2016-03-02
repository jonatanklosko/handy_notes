require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  
  describe "GET #new" do
    it "renders :new" do
      get :new
      expect(response).to render_template :new
    end
  end
  
  describe "POST #create" do
    context "with existig email address" do
      before do
        user = create(:user, email: "sholmes@example.com")
        post :create, user: { email: user.email }
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "flash[:info] contains a message" do
        expect(flash[:info]).to_not be_nil
      end
    end
    
    context "with non-existig email address" do
      before do
        post :create, user: { email: "no@exist.com" }
      end
      
      it "re-renders :new method" do
        expect(response).to render_template 'new'
      end
      
      it "flash[:error] contains a message" do
        expect(flash[:error]).to_not be_nil
      end
    end
  end
  
  describe "GET #edit" do
    context "with invalid reset token" do
      before do
        user = create(:user, email: "sholmes@example.com")
        get :edit, id: "invalid reset token", email: user.email
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "flash[:error] contains a message" do
        expect(flash[:error]).to_not be_nil
      end
    end
    
    context "with valid link" do
      before do
        user = create(:user, email: "sholmes@example.com")
        user.send_password_reset_email
        get :edit, id: user.reset_token, email: user.email
      end
      
      it { is_expected.to render_template :edit }
    end
  end
  
  describe "PATCH #update" do
    context "with valid password and confirmation" do
      before do
        @user = create(:user, email: "sholmes@example.com")
        @user.send_password_reset_email
        patch :update, id: @user.reset_token, email: @user.email,
                          user: { password: 'newpassword',
                                  password_confirmation: 'newpassword' }
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "flash[:success] contains a message" do
        expect(flash[:success]).to_not be_nil
      end
      
      it "user has updated password" do
        @user.reload
        expect(@user.authenticate('newpassword')).to eq(@user)
      end
    end
    
    context "with invalid password and confirmation" do
      before do
        @user = create(:user, email: "sholmes@example.com")
        @user.send_password_reset_email
        patch :update, id: @user.reset_token, email: @user.email,
                          user: { password: 'newpassword',
                                  password_confirmation: 'wrongconfirmation' }
      end
      
      it "re-renders :edit method" do
        expect(response).to render_template 'edit'
      end
      
      it "renders error messages for user" do
        expect(response).to render_template 'users/_user_error_messages'
      end
      
      it "user has not updated password" do
        @user.reload
        expect(@user.authenticate('newpassword')).to be_falsey
      end
    end
  end
end
