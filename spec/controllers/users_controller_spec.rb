require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe "GET #new" do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end
  
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user" do
        expect {
          post :create, user: attributes_for(:user)
        }.to change{ User.count }.by(1)
      end
      
      it "redirects to the root url" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to root_url
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new user" do
        expect {
          post :create, user: attributes_for(:invalid_user)
        }.to_not change{ User.count }
      end
      
      it "re-renders the new method" do
        post :create, user: attributes_for(:invalid_user)
        expect(response).to render_template :new
      end
      
      it "renders error messages partial" do
        post :create, user: attributes_for(:invalid_user)
        expect(response).to render_template(partial: "_user_error_messages")
      end
    end
  end
  
  describe "GET #edit" do
    let(:user) { create(:user) }
    
    context "as a correct user" do
      before do
        sign_in user
        get :edit, username: user.username
      end
      
      it "assigns the correct user to @user" do
        expect(assigns(:user)).to eq(user)
      end
      
      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in path" do
        get :edit, username: user.username
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :edit, username: user.username
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "PATCH #update" do
    let(:user) { create(:user) }
    
    context "when not signed in" do
      before do
        patch :update, username: user.username, update_section: "general",
                                user: { username: "newusername" }
      end
      
      it { is_expected.to redirect_to signin_url }
      
      it "does not modify the user" do
        user.reload
        expect(user.username).to_not eq("newusername")
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      before do
        sign_in other_user
        patch :update, username: user.username, update_section: "general",
                                user: { username: "newusername" }
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "does not modify the user" do
        user.reload
        expect(user.username).to_not eq("newusername")
      end
    end
    
    context "as a correct user with invalid informations" do
      before do
        sign_in user
        patch :update, username: user.username, update_section: "general",
                                user: { username: "" }
      end
        
      it { is_expected.to render_template :edit }
      it { is_expected.to render_template 'users/_user_error_messages' }
      
      it "does not modify the user" do
        user.reload
        expect(user.username).to_not eq("")
      end
    end
    
    context "as a correct user with valid informations" do
      before do
        sign_in user
        patch :update, username: user.username, update_section: "general",
                                user: { username: "newusername" }
      end
        
      it { is_expected.to render_template :edit }
      
      it "flash[:success] contains a message" do
        expect(flash[:success]).to_not be_nil
      end
      
      it "modifies the user" do
        user.reload
        expect(user.username).to eq("newusername")
      end
    end
  end
  
  describe "GET #show" do
    let(:user) { create(:user) }
    
    context "when not signed in" do
      it "redirects to sign in path" do
        get :show, username: user.username
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :show, username: user.username
        expect(response).to redirect_to root_url
      end
    end
    
    context "as a correct user" do
      before do
        sign_in user
        patch :show, username: user.username
      end
      
      it { is_expected.to render_template :show }
    end
  end
end
