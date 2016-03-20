require 'rails_helper'

RSpec.describe Linkset, type: :model do
  it_behaves_like "UserDocument"
  
  it "has a valid factory" do
    expect(build(:linkset)).to be_valid
  end
end
