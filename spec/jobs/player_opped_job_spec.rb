require 'spec_helper'

describe PlayerOppedJob do
  let(:creator) { create :user }
  let(:world)   { create :world, creator: creator }

  let(:player)  { create :user }

  before { world.add_member(player) }

  it "makes the player an op" do
    PlayerOppedJob.new.process! world, player
    world.ops.should include(player)
  end
end
