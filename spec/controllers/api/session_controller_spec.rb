require 'spec_helper'

describe Api::SessionController do
  render_views

  let(:world) { create :world }
  let(:user)  { create :user }
  
  describe '#show' do
    before { user }
    
    context "with bad creds" do
      it "should 500" do
        basic_auth user.username, "carlsmumishot"
        get :show
        assert_response :error 
      end
    end

    context "with good creds" do
      before { basic_auth user.username, "password" }
      
      context "not currently playing" do
        it "should 404" do
          get :show
          assert_response :not_found
        end
      end

      context "currently playing" do
        it "should return session information" do
          User.stub(:by_email_or_username) { [user] }
          user.current_world = world
          
          user.current_world.stub(:current_player_ids) { [user.id] }
          
          get :show
          body = JSON.parse(response.body)
          body['current_world'].should == world.name
        end
      end
    end
  end
end