require 'spec_helper'

describe Worlds::MembershipRequestsController do
  let(:world) { Fabricate(:world) }

  describe '#create' do
    context 'public' do
      before(:each) {
        post :create, user_id: world.creator.minecraft_player.slug, world_id: world.slug
      }

      subject { response }

      it { should redirect_to(new_user_session_path) }
    end

    context 'signed in' do
      signin_as { Fabricate(:user) }

      before {
        WorldMailer.
          should_receive(:membership_request_created).
          with(world.id, anything, world.creator.id) { Struct.new(:deliver).new }
          
        post :create, user_id: world.creator.minecraft_player.slug, world_id: world.slug
      }

      subject { response }

      it { should redirect_to(player_world_path(world.creator.minecraft_player, world)) }

    end
  end
end
