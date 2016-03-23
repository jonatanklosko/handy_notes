require 'rails_helper'

RSpec.describe LinksetLinksController, type: :controller do
  let(:user) { create(:user) }
  let(:linkset) { create(:linkset, user: user) }
  
  before do
    sign_in user
  end

  describe "GET #new (Ajax request)" do
    before do
      xhr :get, :new, format: :js, username: user.username,
                                   linkset_slug: linkset.slug
    end
      
    it "assigns a new LinksetLink to @link" do
      expect(assigns(:link)).to be_a_new(LinksetLink)
    end
    
    it "@link has set the correct linkset_id" do
      expect(assigns(:link).linkset_id).to eq linkset.id
    end
    
    it "renders the new form" do
      expect(response).to render_template(partial: "_new")
    end
  end
  
  describe "POST #create (Ajax request)" do
    let(:link_attributes) { attributes_for(:linkset_link, linkset: linkset) }
    
    it "renders the new link" do
      xhr :post, :create, format: :js, username: user.username,
                  linkset_slug: linkset.slug, linkset_link: link_attributes
      expect(response).to render_template(partial: "_linkset_link")
    end
    
    it "creates a new link that belong to the linkset" do
      expect {
        xhr :post, :create, format: :js, username: user.username,
                  linkset_slug: linkset.slug, linkset_link: link_attributes
      }.to change{ linkset.links.count }.by(1)
    end
  end
  
  describe "GET #edit (Ajax request)" do
    let(:link) { create(:linkset_link, linkset: linkset) }
    before do
      xhr :get, :edit, format: :js, username: user.username,
                       linkset_slug: linkset.slug, id: link
    end
    
    it "assigns the correct linkset link to @link" do
      expect(assigns(:link)).to eq(link)
    end
    
     it "renders the edit form" do
      expect(response).to render_template(partial: "_edit")
    end
  end
  
  describe "PATCH #update (Ajax request)" do
    let(:link) { create(:linkset_link, linkset: linkset, name: "Some name") }
    before do
      xhr :patch, :update, format: :js, username: user.username,
                                linkset_slug: linkset.slug, id: link.id,
                                linkset_link: { name: "New name" }
    end
    
    it "changes the link" do
      expect(link.reload.name).to eq "New name"
    end
    
    it "renders the updated link" do
      expect(response).to render_template(partial: "_linkset_link")
    end
  end
  
  describe "DELETE #destroy (Ajax request)" do
    let!(:link) { create(:linkset_link, linkset: linkset) }
    
    it "decreases the count of links that belong to the linkset" do
      expect {
        xhr :delete, :destroy, format: :js, username: user.username,
                                  linkset_slug: linkset.slug, id: link.id
      }.to change{ linkset.links.count }.by(-1)
    end
  end
end
