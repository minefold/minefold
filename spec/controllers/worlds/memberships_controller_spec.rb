require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:world) { Fabricate(:world) }

  describe '#create' do
    signin_as { world.creator }

    let(:player) { Fabricate :minecraft_player }

    it "adds a whitelisted player to world" do
      post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug, username: player.username

      # TODO Move out to another spec
      response.should redirect_to(player_world_players_path(world.creator.minecraft_player, world))

      world.reload
      world.whitelisted_players.should include(player)
    end
  end
  
  describe '#index' do
    signin_as { world.creator }
    before {
      get :index, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    }
    
    it "works" do
      response.should be_success
    end
    
  end
end
