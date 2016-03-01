require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
    
  describe ".account_activation" do
    let(:user) { create(:user) }
    subject { UserMailer.account_activation(user) }
    
    it { is_expected.to deliver_to user.email }
    it { is_expected.to have_subject "Account activation" }
    it { is_expected.to have_body_text user.username }
    it { is_expected.to have_body_text user.activation_token }
  end
end
