require 'rails_helper'

RSpec.describe SharesController, type: :controller do

  describe "GET #show" do
    context "with existing share_token" do
      let(:note) { create(:note) }
      let(:share) { Share.find_by(destination_path: note.path) }
      
      before do
        get :show, share_token: share.token
      end
      
      it "redirects to the destination_path" do
        expect(response).to redirect_to share.destination_path
      end
      
      it "assigns 'shared' to the destination_path in the session hash" do
        expect(session[share.destination_path]).to eq "shared"
      end
    end
    
    context "with non existing share_token" do
      before do
        get :show, share_token: "non_existing"
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "flash[:error] contains a message" do
        expect(flash[:error]).to_not be_empty
      end
    end
  end
end
