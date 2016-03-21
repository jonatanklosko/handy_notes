shared_examples_for "UserDocumentsController" do |document_class, document_type|

  describe "GET #new" do
    let(:user) { create(:user) }
    
    context "when signed in" do
      before do
        sign_in user
        get :new, username: user.username
      end
      
      it "assigns a new #{document_class} to @#{document_type}" do
        expect(assigns(document_type)).to be_a_new(document_class)
      end
      
      it "@#{document_type} has set the correct user_id" do
        expect(assigns(document_type).user_id).to eq user.id
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
    let(:valid_document_attributes) do
      build(document_type, user: user).attributes
    end
    
    context "as a correct user with valid informations" do   
      before do
        sign_in user
      end
      
      it "creates a new #{document_type}" do
        expect {
          post :create, username: user.username,
                        document_type => valid_document_attributes
        }.to change{ document_class.count }.by(1)
      end
      
      it "increases the count of the documents that belong to the user" do
        expect {
          post :create, username: user.username,
                        document_type => valid_document_attributes
        }.to change{ user.send(document_type.to_s.pluralize).count }.by(1)
      end
      
      it "redirects to the #{document_type}" do
        post :create, username: user.username,
                      document_type => valid_document_attributes
        document = user.documents.first
        expect(response).to redirect_to document.path
      end
    end
    
    context "as a correct user with invalid attributes" do
      let(:invalid_document_attributes) do
        build(document_type, title: "a" * 200, user: user).attributes
      end
      
      before do
        sign_in user
      end
        
      it "re-renders new action" do
        post :create, username: user.username,
                      document_type => invalid_document_attributes
        is_expected.to render_template :new
      end
      
      it "flash[:error] contains a message" do
        post :create, username: user.username,
                      document_type => invalid_document_attributes
        expect(flash[:error]).to_not be_empty
      end
      
      it "does not creates a new #{document_type}" do
        expect {
        post :create, username: user.username,
                      document_type => invalid_document_attributes
        }.to_not change{ document_class.count }
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in url" do
        post :create, username: user.username,
                      document_type => valid_document_attributes
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        post :create, username: user.username,
                      document_type => valid_document_attributes
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "GET #show" do
    let(:user) { create(:user) }
    let(:document) { create(document_type, user: user) }
    
    context "as a correct user" do
      before do
        sign_in user
        get :show, username: user.username, slug: document.slug
      end
      
      it { is_expected.to render_template 'show' }
    end
    
    context "when not signed in" do
      it "redirects to sign in url" do
        get :show, username: user.username, slug: document.slug
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :show, username: user.username, slug: document.slug
        expect(response).to redirect_to root_url
      end
    end
    
    context "when session[#{document_type}.path] is set to 'shared'" do
      before do
        @request.host = Rails.application.routes.default_url_options[:host]
        session[document.path] = "shared"
        get :show, username: user.username, slug: document.slug
      end
      
      it { is_expected.to render_template 'show' }
    end
  end
  
  describe "GET #edit" do
    let(:user) { create(:user) }
    let(:document) { create(document_type, user: user) }
    
    context "as a correct user" do
      before do
        sign_in user
        get :edit, username: user.username, slug: document.slug
      end
      
      it "assigns the correct user to @user" do
        expect(assigns(:user)).to eq(user)
      end
      
      it "assigns the correct #{document_type} to @#{document_type}" do
        expect(assigns(document_type)).to eq(document)
      end
      
      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end
    
    context "when not signed in" do
      it "redirects to sign in path" do
        get :edit, username: user.username, slug: document.slug
        expect(response).to redirect_to signin_url
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      it "redirects to root url" do
        sign_in other_user
        get :edit, username: user.username, slug: document.slug
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:document) { create(document_type, user: user) }
    
    context "as a correct user with valid informations" do
      before do
        sign_in user
        patch :update, username: user.username, slug: document.slug,
                                 document_type => { title: "New title" }
        document.reload
      end
        
      it { is_expected.to redirect_to document.path }
      
      it "modifies the #{document_type}" do
        expect(document.title).to eq("New title")
      end
    end
    
    context "as a correct user with invalid informations" do
      before do
        sign_in user
        patch :update, username: user.username, slug: document.slug,
                                 document_type => { title: "a" * 200 }
      end
        
      it { is_expected.to render_template :edit }
      
      it "flash[:error] contains a message" do
        expect(flash[:error]).to_not be_empty
      end
    end
    
    context "when not signed in" do
      before do
        patch :update, username: user.username, slug: document.slug,
                                 document_type => { title: "New title" }
      end
      
      it { is_expected.to redirect_to signin_url }
      
      it "does not modify the #{document_type}" do
        document.reload
        expect(document.title).to_not eq("New title")
      end
    end
    
    context "as another user" do
      let(:other_user) { create(:user) }
      
      before do
        sign_in other_user
        patch :update, username: user.username, slug: document.slug,
                                 document_type => { title: "New title" }
      end
      
      it { is_expected.to redirect_to root_url }
      
      it "does not modify the #{document_type}" do
        document.reload
        expect(document.title).to_not eq("New title")
      end
    end
  end
end