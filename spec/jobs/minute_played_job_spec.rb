require 'spec_helper'

describe MinutePlayedJob do
  let(:player) { Fabricate(:user) }
  let(:world)  { Fabricate(:world) }

  before { world.add_member(player) }

  it "should increase world minutes played" do
    lambda {
      subject.process! player, world, Time.now
    }.should change(world, :minutes_played).by(1)
  end
end
