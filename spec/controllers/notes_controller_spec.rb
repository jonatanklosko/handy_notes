require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  describe "GET #new" do
    let(:user) { create(:user) }
    
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
  
  describe "POST #create" do
    let(:user) { create(:user) }
    let(:new_note) { build(:note, user: user) }
    
    before do
      sign_in user
    end
      
    it "creates a new note" do
      expect {
        post :create, username: user.username, note: new_note.attributes
      }.to change{ Note.count }.by(1)
    end
    
    it "increases the count of the notes that belong to the user" do
      expect {
        post :create, username: user.username, note: new_note.attributes
      }.to change{ user.notes.count }.by(1)
    end
    
    it "redirects to the note" do
      post :create, username: user.username, note: new_note.attributes
      note = user.notes.first
      expect(response).to redirect_to note_url(user, note)
    end
  end
end
