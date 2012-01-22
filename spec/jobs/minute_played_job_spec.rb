require 'spec_helper'

describe MinutePlayedJob do
  let(:player) { Fabricate(:user) }
  let(:world)  { Fabricate(:world) }

  before { world.add_member player }

  it "should increase world minutes played" do
    subject.process! player, world, Time.now
    world.minutes_played.should == 1
  end
end
