require 'spec_helper'

describe MembershipRequest do
  let(:world) { Fabricate(:world) }
  let(:user) { Fabricate(:user) }

  subject { world.membership_requests.new(user: user) }

  it { should be_embedded_in(:world) }

  it { should belong_to(:user) }
  # it { should validate_presence_of(:minecraft_player) }

  describe "#approve" do
    it "adds the user as a member of the world" do
      subject.approve
      world.reload.whitelisted_players.should include(subject.player)
    end
  end
end
