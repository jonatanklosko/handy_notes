require 'rails_helper'

RSpec.describe Share, type: :model do
  
  describe "token" do
    it "should be automatically generated on creation" do
      share = Share.create
      expect(share.token).to_not be_empty
    end
  end
end
