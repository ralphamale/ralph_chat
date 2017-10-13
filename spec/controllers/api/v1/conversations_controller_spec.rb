require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :controller do
	describe 'GET #index' do
		context 'without authorization' do
      before(:each) do
        get :index, :format => :json
      end

      it "render a json error message" do
        expect(json_response[:errors]).to eql "Not authenticated"
      end

      it { should respond_with 401 }
    end

		context 'with authorization' do
			let(:user) { FactoryGirl.create(:user) }

			before(:each) do
				api_authorization_header user.auth_token
				4.times { FactoryGirl.create(:conversation, :user1 => user, :user2 => FactoryGirl.create(:user)) }
				get :index, :format => :json
			end

			it 'returns 4 conversations from database' do
				expect(json_response.count).to be(4)
			end

			it { should respond_with 200 }
		end
	end

	describe 'POST #create' do
		let(:user) { FactoryGirl.create(:user) }
		let(:recipient_user) { FactoryGirl.create(:user) }

		context 'without authorization' do
      before(:each) do
        post :create, { conversation: { user2_id: recipient_user.id } }
      end

      it "render a json error message" do
        expect(json_response[:errors]).to eql "Not authenticated"
      end

      it { should respond_with 401 }
    end

		context 'with authorization' do
			context 'succesfully created' do
				before(:each) do
					api_authorization_header user.auth_token
					post :create, { conversation: { user2_id: recipient_user.id } }
				end

				it 'renders correct json' do
					expect(json_response[:user1_id]).to eql user.id
					expect(json_response[:user2_id]).to eql recipient_user.id
				end

				it { should respond_with 201 }
			end

			context 'existing conversation' do
				let!(:existing_conversation) do 
					FactoryGirl.create(:conversation, :user1_id => user.id, :user2_id => recipient_user.id)
				end

				before(:each) do
					api_authorization_header user.auth_token
					post :create, { conversation: { user2_id: recipient_user.id } }
				end

				it 'renders existing conversation' do
					expect(json_response[:id]).to eq existing_conversation.id
				end

				it 'does not generate new conversation' do
					expect(Conversation.count).to eq 1
				end

				it { should respond_with 200 }
			end

			context 'missing user2_id' do
				before(:each) do
					api_authorization_header user.auth_token
					post :create, format: :json, conversation: { user2_id: nil }

					it 'renders errors json' do
						expect(json_response).to have_key(:errors)
					end

					it 'renders json errors on why conversation cannot be created' do
						expect(json_response[:errors][:user2_id]).to include "Must exist"
					end

					it { should respond_with 422 }
				end
			end
		end
	end
end
