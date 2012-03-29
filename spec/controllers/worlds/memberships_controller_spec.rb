require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:world) { Fabricate(:world) }

  describe '#create' do
    signin_as { world.creator }

    it "adds a member to world" do
      user = Fabricate(:user)
      post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug, username: user.username

      # TODO Move out to another spec
      response.should redirect_to(player_world_players_path(world.creator.minecraft_player, world))

      world.reload
      world.whitelisted_players.should include(user)
    end
  end


  describe '#search' do
    signin_as { world.creator }

    context 'searching for a potential user' do
      let(:potential_user) { Fabricate :user }

      it "returns the user's id" do
        get :search, player_id: world.creator.minecraft_player.slug, world_id: world.slug, username: potential_user.username, format: :json

        body = JSON.parse(response.body)
        body['id'].should == potential_user.id.to_s
      end
    end

    context 'searching user who already in list' do
      it "returns empty" do
        get :search, player_id: world.creator.minecraft_player.slug, world_id: world.slug, username: world.creator.username, format: :json

        response.body.should == '{}'
      end
    end
  end
end
