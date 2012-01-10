require 'spec_helper'

describe Api::SessionsController do
  render_views

  let(:user) { create :user }

  describe '#create' do
    before { user }

    context "with bad creds" do
      it "should 500" do
        @request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(user.username, 'fakepassword')

        post :create
        assert_response :error
      end
    end

    context "with good creds" do
      it "should work" do
        @request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(user.username, user.password)

        post :create
        assert_response :success
      end
    end
  end
end
