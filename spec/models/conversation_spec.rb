require 'rails_helper'

RSpec.describe Conversation, type: :model do
	it { should have_many(:messages) }
	it { should belong_to(:user1) }
	it { should belong_to(:user2) }

	it { should validate_presence_of(:user1).with_message('must exist') }
	it { should validate_presence_of(:user2).with_message('must exist') }

	describe 'Uniqueness validation for user1 and user2' do
		let(:user1) { FactoryGirl.create(:user) }
		let(:user2) { FactoryGirl.create(:user) }
		subject { FactoryGirl.build(:conversation, :user1_id => user1.id, :user2_id => user2.id) }

		it { should validate_uniqueness_of(:user2_id).scoped_to(:user1_id).with_message('conversation already exists between users') }
	end

	context 'before validation' do
		let!(:user1) { FactoryGirl.create(:user) }
		let!(:user2) { FactoryGirl.create(:user) }		

		it 'should set user1_id to the smaller of the two user ids' do
			conversation = FactoryGirl.create(:conversation, :user1_id => user2.id, :user2_id => user1.id)

			expect(conversation.user1_id).to eq user1.id
			expect(conversation.user2_id).to eq user2.id
		end
	end

	context 'scopes' do
		let(:user1) { FactoryGirl.create(:user) }
		let(:user2) { FactoryGirl.create(:user) }
		let(:user3) { FactoryGirl.create(:user) }

		let!(:conversation1) do
			FactoryGirl.create(:conversation, :user1_id => user1.id, :user2_id => user2.id)
		end
		let!(:conversation2) do
			FactoryGirl.create(:conversation, :user1_id => user1.id, :user2_id => user3.id)
		end

		context '#involving' do
			it 'returns correct conversations' do
				expect(Conversation.involving(user1).to_a).to eq [conversation1, conversation2]
			end
		end

		context '#between' do
			it 'returns correct conversations' do
				expect(Conversation.between(user1, user2).to_a).to eq [conversation1]
			end
		end
	end
end
