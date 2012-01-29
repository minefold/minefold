require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:world)   { Fabricate(:world) }

  context 'signed in' do
    signin_as { world.creator }

    describe 'add non existant user' do
      it "should 404" do
        post :create, user_id: world.creator.slug, world_id: world.slug, id: BSON::ObjectId.new

        response.should be_not_found
      end
    end

    describe 'add real user' do
      let(:user) { Fabricate(:user) }

      it "should add member to world" do
        post :create, user_id: world.creator.slug, world_id: world.slug, id: user.id

        world.reload
        world.members.should include(user)
      end

    end
    
    describe '#search' do
      let(:rando) { Fabricate :user }
      
      it "should return user id" do
        get :search, user_id: world.creator.slug, world_id: world.slug, username: rando.username, format: :json
        
        body = JSON.parse(response.body)
        body['id'].should == rando.id.to_s
      end
    end
  end

end
