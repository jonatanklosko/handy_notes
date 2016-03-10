require 'rails_helper'

RSpec.describe Note, type: :model do
  
  it "has a valid factory" do
    expect(build(:note)).to be_valid
  end
  
  describe "title" do
    context "when is empty" do
      it "should be automatically set to 'Untitled' on creation" do
        note = create(:note, title: "")
        expect(note.title).to eq "Untitled"
      end
    end
    
    it "should be no longer than 80 characters" do
      expect(build(:note, title: "a" * 81)).to_not be_valid
    end
  end
  
  describe "slug" do
    context "when title does not contain any word character" do
      it "should be set to 'note'" do
        expect(create(:note, title: "!@#$%^&*()").slug).to eq "note"
      end
    end
    
    context "when a user have already a note with such a slug" do
      it "should end with -number of duplicates" do
        user = create(:user)
        create(:note, title: "title", user: user)
        duplicate = create(:note, title: "title", user: user)
        expect(duplicate.slug).to eq "title-2"
      end
    end
    
    context "when only another user have a note with such a slug" do
      it "should not end with any additional suffix" do
        user1 = create(:user)
        user2 = create(:user)
        user1_note = create(:note, title: "title", user: user1)
        user2_note = create(:note, title: "title", user: user2)
        
        expect(user1_note.slug).to eq user2_note.slug
      end
    end
    
    context "when the title is updated" do
      it "should be also updated" do
        note = create(:note, title: "title")
        expect(note.slug).to eq "title"
        note.update_attribute :title, "newtitle"
        expect(note.slug).to eq "newtitle"
      end
    end
    
    context "when the title is not updated" do
      it "should not change" do
        note = create(:note, title: "title")
        expect(note.slug).to eq "title"
        note.update_attribute :content, "Slug should not change"
        expect(note.slug).to eq "title"
      end
    end
    
    it "should not be equal to 'new'" do
      expect(create(:note, title: "new").slug).to_not eq "new"
    end
  end
end
