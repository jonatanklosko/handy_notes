require 'rails_helper'

RSpec.describe ChecklistsController, type: :controller do
  
  describe "GET #new" do
    let(:user) { create(:user) }
    
    context "when signed in" do
      before do
        sign_in user
        get :new, username: user.username
      end
      
      it "assigns a new Checklist to @checklist" do
        expect(assigns(:checklist)).to be_a_new(Checklist)
      end
      
      it "@checklist has set the correct user_id" do
        expect(assigns(:checklist).user_id).to eq user.id
      end
      
      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in url" do
        get :new, username: user.username
        expect(response).to redirect_to signin_url
      end
    end
  end
  
  describe "POST #create" do
    let(:user) { create(:user) }
    
    let(:valid_checklist_attributes) do
      build(:checklist, user: user).attributes
    end
    
    context "as a correct user with valid title and new items" do   
      before do
        sign_in user
      end
      
      it "creates a new checklist" do
        expect {
          post :create, username: user.username,
                        checklist: valid_checklist_attributes
        }.to change{ Checklist.count }.by(1)
      end
      
      it "increases the count of the checklists that belong to the user" do
        expect {
          post :create, username: user.username,
                        checklist: valid_checklist_attributes
        }.to change{ user.checklists.count }.by(1)
      end
      
      it "redirects to the checklist" do
        post :create, username: user.username,
                      checklist: valid_checklist_attributes
        checklist = user.checklists.first
        expect(response).to redirect_to checklist_url(user, checklist)
      end
    end
    
    context "as a correct user with invalid attributes" do
      let(:invalid_checklist_attributes) do
        build(:checklist, title: "a" * 200, user: user).attributes
      end
      
      before do
        sign_in user
      end
        
      it "re-renders new action" do
        post :create, username: user.username,
                      checklist: invalid_checklist_attributes
        is_expected.to render_template :new
      end
      
      it "flash[:error] contains a message" do
        post :create, username: user.username,
                      checklist: invalid_checklist_attributes
        expect(flash[:error]).to_not be_empty
      end
      
      it "does not creates a new checklist" do
        expect {
          post :create, username: user.username,
                        checklist: invalid_checklist_attributes
        }.to_not change{ Checklist.count }
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in url" do
        post :create, username: user.username,
                      checklist: valid_checklist_attributes
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        post :create, username: user.username,
                      checklist: valid_checklist_attributes
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "GET #show" do
    let(:user) { create(:user) }
    let(:checklist) { create(:checklist, user: user) }
    
    context "when not signed in" do
      it "redirects to sign in url" do
        get :show, username: user.username, slug: checklist.slug
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :show, username: user.username, slug: checklist.slug
        expect(response).to redirect_to root_url
      end
    end
    
    context "as a correct user" do
      before do
        sign_in user
        get :show, username: user.username, slug: checklist.slug
      end
      
      it { is_expected.to render_template 'show' }
    end
    
    context "when session[checklist.url] is set to 'shared'" do
      before do
        @request.host = Rails.application.routes.default_url_options[:host]
        @request.session[checklist.path] = "shared"
        get :show, { username: user.username, slug: checklist.slug }
      end

      it { is_expected.to render_template 'show' }
    end
  end
  
  describe "GET #edit" do
    let(:user) { create(:user) }
    let(:checklist) { create(:checklist, user: user) }
    
    context "as a correct user" do
      before do
        sign_in user
        get :edit, username: user.username, slug: checklist.slug
      end
      
      it "assigns the correct user to @user" do
        expect(assigns(:user)).to eq(user)
      end
      
      it "assigns the correct checklist to @checklist" do
        expect(assigns(:checklist)).to eq(checklist)
      end
      
      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in path" do
        get :edit, username: user.username, slug: checklist.slug
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :edit, username: user.username, slug: checklist.slug
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:checklist) { create(:checklist, user: user) }
    
    context "when not signed in" do
      before do
        patch :update, username: user.username, slug: checklist.slug,
                                 checklist: { title: "New title" }
      end
      
      it { is_expected.to redirect_to signin_url }
      
      it "does not modify the checklist" do
        checklist.reload
        expect(checklist.title).to_not eq("New title")
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      before do
        sign_in other_user
        patch :update, username: user.username, slug: checklist.slug,
                                 checklist: { title: "New title" }
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "does not modify the checklist" do
        checklist.reload
        expect(checklist.title).to_not eq("New title")
      end
    end
    
    context "as a correct user with invalid informations" do
      before do
        sign_in user
        patch :update, username: user.username, slug: checklist.slug,
                                 checklist: { title: "a" * 200 }
      end
        
      it { is_expected.to render_template :edit }
      
      it "flash[:error] contains a message" do
        expect(flash[:error]).to_not be_empty
      end
    end
    
    context "as a correct user with valid informations" do
      before do
        sign_in user
        patch :update, username: user.username, slug: checklist.slug,
                                 checklist: { title: "New title" }
        checklist.reload
      end
        
      it { is_expected.to redirect_to checklist_url(user, checklist) }
      
      it "modifies the checklist" do
        expect(checklist.title).to eq("New title")
      end
    end
  end
  
  describe "PATCH toggle_item" do
    let(:user) { create(:user) }
    let(:checklist) { create(:checklist, user: user) }
    let(:checked_item) { create(:checklist_item, checklist: checklist, checked: true) }
    let(:unchecked_item) { create(:checklist_item, checklist: checklist, checked: false) }
    
    context "as correct user" do
      before do
        sign_in user
      end
      
      context "when item is not checked" do
        it "changes the item's checked attribute to true" do
          patch :toggle_item, username: user.username, slug: checklist.slug,
                                   item_id: unchecked_item.id
          unchecked_item.reload
          expect(unchecked_item).to be_checked
        end
      end
      
      context "when item is checked" do
        it "changes the item's checked attribute to false" do
          patch :toggle_item, username: user.username, slug: checklist.slug,
                                   item_id: checked_item.id
          checked_item.reload
          expect(checked_item).to_not be_checked
        end
      end
    end
    
    context "when not signed in" do
      before do
        patch :toggle_item, username: user.username, slug: checklist.slug,
                                 item_id: unchecked_item.id
      end
      
      it { is_expected.to redirect_to signin_url }
      
      it "does not modify the item status" do
        unchecked_item.reload
        expect(unchecked_item).to_not be_checked
      end
    end
    
    context "as another user" do
      let(:another_user) { create(:user) }
      
      before do
        sign_in another_user
        patch :toggle_item, username: user.username, slug: checklist.slug,
                                 item_id: unchecked_item.id
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "does not modify the item status" do
        unchecked_item.reload
        expect(unchecked_item).to_not be_checked
      end
    end
  end
end
