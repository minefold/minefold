require 'spec_helper'

describe MinutePlayedJob do
  let(:player) { create :user }
  let(:world)  { create :world }
  
  before { world.add_player player }
  
  it "should increase world minutes played" do
    MinutePlayedJob.perform player.id, world.id, Time.now

    world.minutes_played.should == 1
  end
end
