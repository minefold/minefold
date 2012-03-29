require 'spec_helper'

describe MinutePlayedJob do
  let(:player) { Fabricate(:minecraft_player) }
  let(:world)  { Fabricate(:world) }

  it "should increase world minutes played" do
    MinutePlayedJob.perform player.id, world.id, Time.now
    world.reload.minutes_played.should == 1
  end

  it "should increase player minutes played" do
    MinutePlayedJob.perform player.id, world.id, Time.now
    player.reload.minutes_played.should == 1
  end
end
