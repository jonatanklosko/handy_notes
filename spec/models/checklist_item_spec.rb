require 'rails_helper'

RSpec.describe ChecklistItem, type: :model do
    
  it "has a valid factory" do
    expect(build(:checklist_item)).to be_valid
  end
end
