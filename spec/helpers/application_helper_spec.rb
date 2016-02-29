require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  
  describe "#full_title" do
    context "when no subtitle is given" do
      it "returns the website name" do
        expect(helper.full_title).to eq("Handy Notes")
      end
    end
    
    context "when a subtitle is given" do
      it "returns title containing the website name and the subtitle" do
        expect(helper.full_title("Sign up")).to eq("Handy Notes | Sign up")
      end
    end
  end
end
