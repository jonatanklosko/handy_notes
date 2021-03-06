require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end
  
  describe "username" do
    it "should not be nil" do
      expect(build(:user, username: nil)).to_not be_valid
    end
    
    it "should not be empty" do
      expect(build(:user, username: "")).to_not be_valid
    end
    
    it "should not be blank" do
      expect(build(:user, username: "      ")).to_not be_valid
    end
    
    it "should not be shorter than 6 characters" do
      expect(build(:user, username: "a" * 5)).to_not be_valid
    end
    
    it "should be no longer than 20 characters" do
      expect(build(:user, username: "a" * 21)).to_not be_valid
    end
    
    it "should be unique" do
      create(:user, username: "username")
      expect(build(:user, username: "username")).to_not be_valid
    end
  end
  
  describe "email" do
    it "should not be nil" do
      expect(build(:user, email: nil)).to_not be_valid
    end
    
    it "should not be empty" do
      expect(build(:user, email: "")).to_not be_valid
    end
    
    it "should not be blank" do
      expect(build(:user, email: "      ")).to_not be_valid
    end
    
    ["user@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org",
    "first.last@foo.hk", "frodo+amazon@baz.cn"]
    .each do |email|
      it "#{email} should be valid" do
        expect(build(:user, email: email)).to be_valid
      end                   
    end
    
    ["user@example,com", "missing_at_sign.org",
    "user@foo@bar_baz.com", "foo@baz+bar.com",
    "user@end", "user@example.", "@example.com","foo@bar..com"]
    .each do |email|
      it "#{email} should be invalid" do
        expect(build(:user, email: email)).to_not be_valid
      end
    end
    
    it "should be unique" do
      create(:user, email: "email@gmail.com")
      expect(build(:user, email: "email@gmail.com")).to_not be_valid
    end
  end
  
  describe "password" do
    it "should not be blank" do
      expect(build(:user, username: "      ")).to_not be_valid
    end
    
    it "should not be shorter than 6 characters" do
      expect(build(:user, password: "a" * 5)).to_not be_valid
    end
  end
  
  describe "activation_digest" do
    context "when user is created" do
      it "should not be nil" do
        user = create(:user)
        expect(user.activation_digest).to_not be_nil
      end
    end
  end
  
  describe "#send_activation_email" do
    it "sends the email" do
      user = create(:user)
      expect {
        user.send_activation_email
      }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end
  
  describe "#send_password_reset_email" do
    it "sends the email" do
      user = create(:user)
      expect {
        user.send_password_reset_email
      }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end
  
  describe "#documents" do
    let(:user) { create(:user) }
    
    it "returns an Array containing all the documents of all types"\
      " that belongs to the user" do
      note = create(:note, user: user)
      checklist = create(:checklist, user: user)
      expect(user.documents).to contain_exactly(note, checklist)
    end
    
    it "documents are ordered descending by a date of an update" do
      three_days_ago = create(:note, user: user, updated_at: 3.days.ago)
      five_days_ago = create(:checklist, user: user, updated_at: 5.days.ago)
      one_week_ago = create(:note, user: user, updated_at: 1.week.ago)
      now = create(:checklist, user: user, updated_at: Time.now)
      expect(user.documents).to eq [now, three_days_ago, five_days_ago, one_week_ago]
    end
  end
end
