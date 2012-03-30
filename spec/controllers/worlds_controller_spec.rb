require 'spec_helper'

describe WorldsController do
  render_views

  describe "#create" do
    signin_as { Fabricate(:user) }

    before {
      post :create, world: {
        name: 'minebnb',
        game_mode: '1',
        level_type: 'FLAT',
        seed: 's33d',
        difficulty: '0',
        pvp: '1',
        spawn_monsters: '0',
        spawn_animals: '1',
        generate_structures: '1',
        spawn_npcs: '0'
      }
    }

    subject { World.where(name: 'minebnb').first }

    its(:game_mode) { should == 1 }
    its(:level_type) { should == 'FLAT' }
    its(:seed) { should == 's33d' }
    its(:difficulty) { should == 0 }
    its(:pvp) { should == true }
    its(:spawn_monsters) { should == false }
    its(:spawn_animals) { should == true }
    its(:generate_structures) { should == true }
    its(:spawn_npcs) { should == false }

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
