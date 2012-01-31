require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:world) { Fabricate(:world) }

  describe '#create' do
    signin_as { world.creator }

    it "doesn't add non existant users" do
      post :create, user_id: world.creator.slug, world_id: world.slug, id: BSON::ObjectId.new

      # TODO Not the proper response (should be 422)
      response.should be_not_found
    end

    it "adds a member to world" do
      user = Fabricate(:user)

      post :create, user_id: world.creator.slug, world_id: world.slug, id: user.id

      # TODO Move out to another spec
      response.should redirect_to(user_world_members_path(world.creator, world))

      world.reload
      world.members.should include(user)
    end
  end


  describe '#search' do
    signin_as { world.creator }

    context 'searching for a potential user' do
      let(:potential_user) { Fabricate :user }

      it "returns the user's id" do
        get :search, user_id: world.creator.slug, world_id: world.slug, username: potential_user.username, format: :json

        body = JSON.parse(response.body)
        body['id'].should == potential_user.id.to_s
      end
    end

    context 'searching user who already in list' do
      it "returns empty" do
        get :search, user_id: world.creator.slug, world_id: world.slug, username: world.creator.username, format: :json

        response.body.should == '{}'
      end
    end
  end
end
