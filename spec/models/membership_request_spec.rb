require 'spec_helper'

describe MembershipRequest do
  let(:world) { Fabricate(:world) }
  let(:player) { Fabricate(:minecraft_player) }

  subject { world.membership_requests.new(minecraft_player: player) }

  it { should be_embedded_in(:world) }

  it { should belong_to(:minecraft_player) }
  it { should validate_presence_of(:minecraft_player) }

  describe "#approve" do
    it "adds the user as a member of the world" do
      subject.approve
      world.reload.whitelisted_players.should include(subject.minecraft_player)
    end
  end
end
