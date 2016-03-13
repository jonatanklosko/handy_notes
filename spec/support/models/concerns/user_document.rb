shared_examples_for "UserDocument" do
  let(:document_type) { described_class.name.underscore.to_sym }
  
  describe "title" do
    context "when is empty" do
      it "should be automatically set to 'Untitled' on creation" do
        document = create(document_type, title: "")
        expect(document.title).to eq "Untitled"
      end
    end
    
    it "should be no longer than 80 characters" do
      expect(build(document_type, title: "a" * 81)).to_not be_valid
    end
  end
  
  describe "slug" do
    context "when title does not contain any word character" do
      it "should be set to 'document'" do
        expect(create(document_type, title: "!@#$%^&*()").slug).to eq "document"
      end
    end
    
    context "when a user have already a document"\
           " of the same type with such a slug" do
      it "should end with -number of duplicates" do
        user = create(:user)
        create(document_type, title: "title", user: user)
        duplicate = create(document_type, title: "title", user: user)
        expect(duplicate.slug).to eq "title-2"
      end
    end
    
    context "when only another user have a document of the same type"\
           " with such a slug" do
      it "should not end with any additional suffix" do
        user1 = create(:user)
        user2 = create(:user)
        user1_document = create(document_type, title: "title", user: user1)
        user2_document = create(document_type, title: "title", user: user2)
        
        expect(user1_document.slug).to eq user2_document.slug
      end
    end
    
    context "when the title is updated" do
      it "should be also updated" do
        document = create(document_type, title: "title")
        expect(document.slug).to eq "title"
        document.update_attribute :title, "newtitle"
        expect(document.slug).to eq "newtitle"
      end
    end
    
    context "when the title is not updated" do
      it "should not change" do
        document = create(document_type, title: "title")
        expect(document.slug).to eq "title"
        document.update_attribute :updated_at, Time.now
        expect(document.slug).to eq "title"
      end
    end
    
    it "should not be equal to 'new'" do
      expect(create(document_type, title: "new").slug).to_not eq "new"
    end
  end
end
