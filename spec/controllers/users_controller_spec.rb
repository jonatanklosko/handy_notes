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
end
