require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
	describe 'GET #index' do
		let(:user) { FactoryGirl.create(:user) }
		let(:recipient_user) { FactoryGirl.create(:user) }
		let(:conversation) { FactoryGirl.create(:conversation, :user1_id => user.id, :user2_id => recipient_user.id) }

		context 'without authorization' do
			context 'no request header' do
				before(:each) do
					get :index, :conversation_id => conversation.id, :format => :json
				end

		    it "render a json error message" do
		      expect(json_response[:errors]).to eql "Not authenticated"
		    end

		    it { should respond_with 401 }
			end

			context 'current_user not part of conversation' do
				let(:unauthorized_conversation) do
					FactoryGirl.create(
						:conversation,
						:user1_id => FactoryGirl.create(:user).id,
						:user2_id => FactoryGirl.create(:user).id
					)
				end

				before(:each) do
					api_authorization_header user.auth_token
					get :index, :conversation_id => unauthorized_conversation.id, :format => :json
				end

		    it "render a json error message" do
		      expect(json_response[:errors]).to eql "You must be a part of this conversation"
		    end

		    it {  should respond_with 401 }
		  end
		end

		context 'with authorization' do
			before(:each) do
				api_authorization_header user.auth_token

				4.times do
					FactoryGirl.create(:message, :author => user, :conversation => conversation)
				end

				get :index, :conversation_id => conversation.id, :format => :json
			end

			it 'returns 4 messages from conversation from database' do
				json_response_ids = json_response.map { |message_json| message_json[:id] }

				expect(json_response_ids).to eq(conversation.messages.map(&:id))
			end

			it { should respond_with 200 }
		end
	end

	describe 'POST #create' do
		let(:user) { FactoryGirl.create(:user) }
		let(:recipient_user) { FactoryGirl.create(:user) }
		let(:conversation) { FactoryGirl.create(:conversation, :user1_id => user.id, :user2_id => recipient_user.id) }
		let(:message_attributes) { FactoryGirl.attributes_for :message }

		context 'without authorization' do
			context 'no authorization header' do
				before(:each) do
					post :create, { :format => :json, conversation_id: conversation.id, user_id: recipient_user.id, message: message_attributes }
				end

		    it "render a json error message" do
		      expect(json_response[:errors]).to eql "Not authenticated"
		    end

		    it {  should respond_with 401 }
			end

			context 'current_user not part of conversation' do
				let(:unauthorized_conversation) do
					FactoryGirl.create(
						:conversation,
						:user1_id => FactoryGirl.create(:user).id,
						:user2_id => FactoryGirl.create(:user).id
					)
				end

				before(:each) do
					api_authorization_header user.auth_token
					post :create, { :format => :json, conversation_id: unauthorized_conversation.id, user_id: recipient_user.id, message: message_attributes }
				end

		    it "render a json error message" do
		      expect(json_response[:errors]).to eql "You must be a part of this conversation"
		    end

		    it {  should respond_with 401 }
		  end
		end

		context 'with authorization' do
			context 'succesfully created' do
				before(:each) do
					api_authorization_header user.auth_token
					post :create, { :format => :json, conversation_id: conversation.id, user_id: recipient_user.id, message: message_attributes }
				end

				it 'renders correct json' do
					message_response = json_response
					expect(message_response[:content]).to eql message_attributes[:content]
				end

				it { should respond_with 201 }

				context 'not created' do
					let(:invalid_message_attributes) { { content: '' } }

					before(:each) do
						user = FactoryGirl.create(:user)
						api_authorization_header user.auth_token
						post :create, { :format => :json, conversation_id: conversation.id, user_id: user.id, message: invalid_message_attributes }
					end

					it 'renders an errors json' do
						message_response = json_response
						expect(message_response).to have_key(:errors)
					end

					it 'renders json errors on why message could not be created' do
						expect(json_response[:errors][:content]).to include "can't be blank"
					end

					it { should respond_with 422 }
				end
			end
		end
	end
end
