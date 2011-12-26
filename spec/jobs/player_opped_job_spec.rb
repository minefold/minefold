require 'spec_helper'

describe PlayerOppedJob do
  let(:creator) { create :user }
  let(:world)   { create :world, creator: creator }
  
  let(:player)  { create :user }
  
  before { world.add_player player }
  
  it "should op player" do
    PlayerOppedJob.perform world.id, player.username
    world.ops.to_a.should eq([player])
  end
end