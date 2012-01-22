require 'spec_helper'

describe Worlds::MembershipRequestsController do
  let(:world) { Fabricate(:world) }

  describe '#create' do
    context 'public' do
      # REVISIT
      before(:each) {
        post :create, user_id: world.creator.slug, world_id: world.slug
      }

      it 'is unauthorized' do
        response.should redirect_to(new_user_session_path)
      end
    end

    context 'signed in' do
      signin_as { Fabricate(:user) }

      # REVISIT
      before {
        post :create, user_id: world.creator.slug, world_id: world.slug
      }

      it "sends an email" do
        WorldMailer.should_receive(:membership_request_created)
      end

      it "redirects back to the world" do
        response.should redirect_to(user_world_path(world.creator, world))
      end
    end
  end
end
