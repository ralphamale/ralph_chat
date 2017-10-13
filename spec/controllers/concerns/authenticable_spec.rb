require 'rails_helper'

class FakeAuthenticationController < ApplicationController
  include Authenticable
end

describe Authenticable do
  subject { FakeAuthenticationController.new }
  let(:user) { FactoryGirl.create(:user) }

  describe "#current_user" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      api_authorization_header user.auth_token
      subject.stub(:request).and_return(request)
    end
    it "returns the user from the authorization header" do
      expect(subject.current_user.auth_token).to eql user.auth_token
    end
  end

  describe "#authenticate_with_token" do
    before do
      subject.stub(:current_user).and_return(nil)
      response.stub(:response_code).and_return(401)
      response.stub(:body).and_return({"errors" => "Not authenticated"}.to_json)
      subject.stub(:response).and_return(response)
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

    it {  should respond_with 401 }
  end

  describe "#user_signed_in?" do
    context "when there is a user on 'session'" do
      before do
        subject.stub(:current_user).and_return(user)
      end

      it { should be_user_signed_in }
    end

    context "when there is no user on 'session'" do
      before do
        subject.stub(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end