require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  
  describe "GET #new" do
    it "renders :new" do
      get :new
      expect(response).to render_template :new
    end
  end
  
  describe "POST #create" do
    context "with valid attributes" do
      before do  
        create(:user, username: "sherlock", password: "password")
        post :create, user: { username: "sherlock", password: "password" }
      end
      
      it "redirects to the root url" do
        expect(response).to redirect_to root_url
      end
      
      it "flash[:success] contains message" do
        expect(flash[:success]).to_not be_empty
      end
    end
    
    context "with invalid attributes" do
      before do
        create(:user, username: "sherlock", password: "password")
        post :create, user: { username: "holmes", password: "password" }
      end
      
      it "re-renders new action" do
        expect(response).to render_template :new
      end
      
      it "flash[:error] contains message" do
        expect(flash[:error]).to_not be_empty
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "when a user is signed in" do
      before do
        create(:user, username: "sherlock", password: "password")
        post :create, user: { username: "sherlock", password: "password" }
      end
      
      it "redirects to the root url" do
        delete :destroy
        expect(response).to redirect_to root_url
      end
    end
    
    context "when a user is signed out" do
      it "redirects to the root url" do
        delete :destroy
        expect(response).to redirect_to root_url
      end
    end
  end
end
