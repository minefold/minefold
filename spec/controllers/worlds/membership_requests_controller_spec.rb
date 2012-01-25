require 'spec_helper'

describe Worlds::MembershipRequestsController do
  let(:world) { Fabricate(:world) }

  describe '#create' do
    context 'public' do
      before(:each) {
        post :create, user_id: world.creator.slug, world_id: world.slug
      }

      subject { response }

      it { should redirect_to(new_user_session_path) }
    end

    context 'signed in' do
      signin_as { Fabricate(:user) }

      before {
        post :create, user_id: world.creator.slug, world_id: world.slug
      }

      subject { response }

      it { should redirect_to(user_world_path(world.creator, world)) }

      it "sends an email" do
        WorldMailer.should_receive(:membership_request_created)
      end
    end
  end
end
