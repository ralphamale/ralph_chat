require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    context 'without authorization' do
      before(:each) do
        get :index, :format => :json
      end

      it "render a json error message" do
        expect(json_response[:errors]).to eql "Not authenticated"
      end

      it {  should respond_with 401 }
    end

    context 'with authorization' do
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do
        api_authorization_header user.auth_token
        4.times { FactoryGirl.create(:user) }
        get :index, :format => :json
      end

      it 'returns 5 users from database' do
        expect(json_response.count).to be(5)
      end

      it { should respond_with 200 }
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      let(:valid_user_attributes) { FactoryGirl.attributes_for(:user) }
      before(:each) do
        post :create, user: valid_user_attributes, format: :json
      end

      it "renders the json representation for the user record just created" do
        expect(json_response[:email]).to eql valid_user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      let(:invalid_user_attributes) do
          {
            password: "12345678",
            password_confirmation: "12345678"
          }
      end

      before(:each) do
        post :create, { user: invalid_user_attributes }, format: :json
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
end
