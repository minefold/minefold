require 'spec_helper'

describe InvitesController do
  signin_as { Fabricate :user }

  describe '#create' do
    context 'facebook invite' do

      it "creates a facebook invite" do
        post :create, invite: { facebook_uid: '1234567' }

        current_user.reload.invites.should have(1).invite
      end
    end
  end
end