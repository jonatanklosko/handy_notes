require 'rails_helper'

RSpec.describe LinksetLink, type: :model do
  
  it "has a valid factory" do
    expect(build(:linkset_link)).to be_valid
  end
end
