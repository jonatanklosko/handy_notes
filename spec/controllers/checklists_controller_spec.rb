require 'rails_helper'

RSpec.describe ChecklistsController, type: :controller do
  it_behaves_like "UserDocumentsController", Checklist, :checklist
  
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
