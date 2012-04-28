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
        UserMailer.
          should_receive(:membership_request_created).
          with(anything, world.id, world.creator.id) {
            mailer = double('mailer')
            mailer.should_receive(:deliver)
            mailer
          }

        post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug
      }

      subject { response }

      it { should redirect_to(player_world_path(world.creator.minecraft_player, world)) }

    end
  end

  describe '#approve' do
  end
end
