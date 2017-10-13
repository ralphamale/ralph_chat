require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }
  subject { user }

	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
	it { should validate_confirmation_of(:password) }

	it { should allow_value('example@domain.com').for(:email) }
	it { should validate_uniqueness_of(:auth_token) }

  it { should have_many(:messages) }
  it { should validate_uniqueness_of(:auth_token)}

  describe '#conversations' do
    let(:another_user) { FactoryGirl.create(:user) }
    let(:conversation) { FactoryGirl.create(:conversation, :user1_id => subject.id, :user2_id => another_user.id) }

    before do
      allow(Conversation).to receive(:involving)
    end
    
    it 'calls "involving" scope on Conversation' do
      expect(Conversation).to receive(:involving).with(user)

      subject.conversations
    end
  end

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      subject.generate_authentication_token!
      expect(subject.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken1234")
      subject.generate_authentication_token!
      expect(subject.auth_token).not_to eql existing_user.auth_token
    end
  end
end
