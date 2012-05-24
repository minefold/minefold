require 'spec_helper'

describe WorldMinutePlayedJob do
  let(:world)  { Fabricate(:world) }

  it "increases world minutes played" do
    WorldMinutePlayedJob.perform world.id, Time.now
    world.reload.world_minutes_played.should == 1
  end

  it "schedules a map every 60 minutes" do
    world.world_minutes_played = 59
    world.save!

    Resque.should_receive(:push).with('maps_low', class: 'Job::MapWorld', args: [world.id.to_s])

    WorldMinutePlayedJob.perform world.id, Time.now
  end
end
