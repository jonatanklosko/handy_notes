require 'rails_helper'

RSpec.describe Checklist, type: :model do  
  it_behaves_like "UserDocument"
  
  it "has a valid factory" do
    expect(build(:checklist)).to be_valid
  end
end
