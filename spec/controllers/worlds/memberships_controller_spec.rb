require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:creator) { Fabricate(:user) }
  let(:world)   { Fabricate(:world) }

  context 'signed in' do
    signin_as { world.creator }
    
    describe 'add non existant user' do
      it "should 404" do
        post :create, user_id: world.creator.slug, world_id: world.slug, id: BSON::ObjectId.new
        
        response.status.should == 404
      end
    end
    
    describe 'add real user' do
      let(:rando) { Fabricate(:user) }

      it "should add member to world" do
        post :create, user_id: world.creator.slug, world_id: world.slug, id: rando.id
        
        world.reload
        world.members.should include(rando)
      end
      
    end
  end

end
