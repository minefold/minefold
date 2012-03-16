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

    it { response.should redirect_to(player_world_path(current_user.player, 'minebnb')) }
  end

  describe "#show" do
    let(:world) { Fabricate(:world) }

    it "renders" do
      get :show, user_id: world.creator.minecraft_player.slug, id: world.slug
      response.should be_successful
    end

    context 'signed in as the creator' do
      signin_as { world.creator }
    end

    context 'signed in as an op' do
      # signin_as { subject.creator }
    end

    context 'signed in as a player' do
      signin_as { world.creator }

      context "who hasn't played before" do
        before {
          get :show, user_id: world.creator.minecraft_player.slug, id: world.slug
        }
        subject { response }

        its(:body) { should include(current_user.host) }
      end
    end
  end

  describe '#join' do
    let(:member) { Fabricate(:user) }
    let(:world) { Fabricate(:world) }

    context 'public' do
      before { post :join, user_id: world.creator.minecraft_player.slug, id: world.slug }
      it "is unauthorized"
    end

    context 'member' do
      before {
        @request.env['devise.mapping'] = Devise.mappings[:user]

        world.add_member(member)
        world.save!

        sign_in member

        post :join, user_id: world.creator.minecraft_player.slug, id: world.slug
      }

      subject { response }

      it { should redirect_to(player_world_path(world.creator.minecraft_player, world)) }

      it "sets the user's current world" do
        member.reload
        member.current_world.should == world
      end
    end

    context 'already joined' do
      signin_as { Fabricate(:user, current_world: world) }
      before { world.add_member(current_user) }

      it "does nothing" do
        lambda {
          post :join, user_id: world.creator.minecraft_player.slug, id: world.slug
        }.should_not change(current_user, :current_world)
      end
    end
  end

  describe '#clone' do
    let(:world) { Fabricate(:world) }
    signin_as { Fabricate(:user) }

    before {
      post :clone, user_id: world.creator.minecraft_player.slug, id: world.slug
    }

    subject { response }

    it { should redirect_to(player_world_path(current_user.player, world.slug)) }
  end
  
  describe '#destroy' do
    let(:player) { Fabricate :user }
    let(:member) { Fabricate :user }
    let(:world) { Fabricate :world }
    
    signin_as { world.creator }
    
    before {
      world.add_member(member)
      world.add_member(player)
      player.current_world = world
      world.save
      
      WorldMailer.should_receive(:world_deleted).
        with(world.name, world.creator.username, player.id) { Struct.new(:deliver).new }
      
      delete :destroy, user_id: world.creator.minecraft_player.slug, id: world.slug
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
