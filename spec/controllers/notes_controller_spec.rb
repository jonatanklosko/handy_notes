require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  describe "GET #new" do
    let(:user) { create(:user) }
    
    context "when signed in" do
      before do
        sign_in user
        get :new, username: user.username
      end
      
      it "assigns a new Note to @note" do
        expect(assigns(:note)).to be_a_new(Note)
      end
      
      it "@note has set the correct user_id" do
        expect(assigns(:note).user_id).to eq user.id
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
    let(:valid_note_attributes) { build(:note, user: user).attributes }
    
    context "as a correct user with valid informations" do   
      before do
        sign_in user
      end
      
      it "creates a new note" do
        expect {
          post :create, username: user.username, note: valid_note_attributes
        }.to change{ Note.count }.by(1)
      end
      
      it "increases the count of the notes that belong to the user" do
        expect {
          post :create, username: user.username, note: valid_note_attributes
        }.to change{ user.notes.count }.by(1)
      end
      
      it "redirects to the note" do
        post :create, username: user.username, note: valid_note_attributes
        note = user.notes.first
        expect(response).to redirect_to note_url(user, note)
      end
    end
    
    context "as a correct user with invalid attributes" do
      let(:invalid_note_attributes) { build(:note, title: "a" * 200, user: user).attributes }
      
      before do
        sign_in user
      end
        
      it "re-renders new action" do
        post :create, username: user.username, note: invalid_note_attributes
        is_expected.to render_template :new
      end
      
      it "flash[:error] contains a message" do
        post :create, username: user.username, note: invalid_note_attributes
        expect(flash[:error]).to_not be_empty
      end
      
      it "does not creates a new note" do
        expect {
          post :create, username: user.username, note: invalid_note_attributes
        }.to_not change{ Note.count }
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in url" do
        post :create, username: user.username, note: valid_note_attributes
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        post :create, username: user.username, note: valid_note_attributes
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "GET #show" do
    let(:user) { create(:user) }
    let(:note) { create(:note, user: user) }
    
    context "when not signed in" do
      it "redirects to sign in url" do
        get :show, username: user.username, slug: note.slug
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :show, username: user.username, slug: note.slug
        expect(response).to redirect_to root_url
      end
    end
    
    context "as a correct user" do
      before do
        sign_in user
        get :show, username: user.username, slug: note.slug
      end
      
      it { is_expected.to render_template 'show' }
    end
  end
  
  describe "GET #edit" do
    let(:user) { create(:user) }
    let(:note) { create(:note, user: user) }
    
    context "as a correct user" do
      before do
        sign_in user
        get :edit, username: user.username, slug: note.slug
      end
      
      it "assigns the correct user to @user" do
        expect(assigns(:user)).to eq(user)
      end
      
      it "assigns the correct note to @note" do
        expect(assigns(:note)).to eq(note)
      end
      
      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in path" do
        get :edit, username: user.username, slug: note.slug
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :edit, username: user.username, slug: note.slug
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:note) { create(:note, user: user) }
    
    context "when not signed in" do
      before do
        patch :update, username: user.username, slug: note.slug,
                                 note: { content: "New content" }
      end
      
      it { is_expected.to redirect_to signin_url }
      
      it "does not modify the note" do
        note.reload
        expect(note).to_not eq("New content")
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      before do
        sign_in other_user
        patch :update, username: user.username, slug: note.slug,
                                 note: { content: "New content" }
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "does not modify the note" do
        note.reload
        expect(note.content).to_not eq("New content")
      end
    end
    
    context "as a correct user with invalid informations" do
      before do
        sign_in user
        patch :update, username: user.username, slug: note.slug,
                                 note: { title: "a" * 200 }
      end
        
      it { is_expected.to render_template :edit }
      
      it "flash[:error] contains a message" do
        expect(flash[:error]).to_not be_empty
      end
    end
    
    context "as a correct user with valid informations" do
      before do
        sign_in user
        patch :update, username: user.username, slug: note.slug,
                                 note: { content: "New content" }
        note.reload
      end
        
      it { is_expected.to redirect_to note_url(user, note) }
      
      it "modifies the note" do
        expect(note.content).to eq("New content")
      end
    end
  end
end
