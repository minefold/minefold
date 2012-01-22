require 'spec_helper'

describe Api::SessionsController do
  render_views

  let(:user)  { Fabricate(:user) }

  describe '#show' do

    context "unauthorized" do
      it "errors" do
        basic_auth user.username, "bad password"
        get :show
        assert_response :error
      end
    end

    context "authorized" do
      before { basic_auth(user.username, 'password') }

      it "should return session information" do
        User.stub(:by_email_or_username) { [user] }

        user.current_world.stub(:current_player_ids) { [user.id] }

        get :show
        body = JSON.parse(response.body)
        body['current_world'].should == world.name
      end
    end
  end
end