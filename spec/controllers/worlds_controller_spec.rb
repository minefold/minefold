require 'spec_helper'

describe WorldsController do
  render_views

  describe "#create" do
    signin_as { Fabricate(:user) }

    before {
      post :create, world: {
        name: 'minebnb'
      }
    }

    it { response.should redirect_to(player_world_path(current_user.minecraft_player, 'minebnb')) }
  end

  describe "#show" do
    let(:world) { Fabricate(:world) }

    it "renders" do
      get :show, player_id: world.creator.minecraft_player.slug, id: world.slug
      response.should be_successful
    end
  end

  describe '#clone' do
    let(:world) { Fabricate(:world) }
    signin_as { Fabricate(:user) }

    before {
      post :clone, player_id: world.creator.minecraft_player.slug, id: world.slug
    }

    subject { response }

    it { should redirect_to(player_world_path(current_user.minecraft_player, world.slug)) }
  end

  describe '#destroy' do
    let(:user) { Fabricate :user }
    let(:whitelisted_player) { user.minecraft_player }
    let(:world) { Fabricate :world, whitelisted_players: [whitelisted_player] }

    signin_as { world.creator }

    before {
      WorldMailer.should_receive(:world_deleted).
        with(world.name, world.creator.username, user.id) { Struct.new(:deliver).new }

      delete :destroy, player_id: world.creator.minecraft_player.slug, id: world.slug
    }

    it "safe deletes world" do
      World.where(_id: world.id).should be_empty
      World.unscoped.where(_id: world.id).should have(1).world
    end

    it "redirects to dashboard" do
      response.should redirect_to user_root_path
    end
  end
end
