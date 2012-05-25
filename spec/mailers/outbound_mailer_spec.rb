require "spec_helper"

describe OutboundMailer do
  describe "invite" do
    let(:world) { Fabricate :world }
    let(:invitor) { Fabricate :user }
    subject { OutboundMailer.invite(invitor.minecraft_player.id, world.id, 'dave@minefold.com', "") }

    its(:to) { should include('dave@minefold.com') }
    its(:body) { should include(invitor.minecraft_player.username) }
  end
end