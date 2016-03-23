require 'rails_helper'

RSpec.describe LinksetLink, type: :model do
  
  it "has a valid factory" do
    expect(build(:linkset_link)).to be_valid
  end
  
  describe "url" do
    context "when does not contain any scheme" do
      it "should add it automaticaly" do
        link = build(:linkset_link, url: "google.com")
        expect(link.url).to eq "http://google.com"
      end
    end
    
    context "when contains a scheme" do
      it "should not change" do
        link = build(:linkset_link, url: "https://google.com")
        expect(link.url).to eq "https://google.com"
      end
    end
  end
end
