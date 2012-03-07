require 'spec_helper'

describe PlayerDisconnectedJob do
  let(:world) { Fabricate :world }
  let(:player) { Fabricate :user, current_world: world }

  it "records event" do
    PlayerDisconnectedJob.perform player.username, Time.now

    world.events.should have(1).disconnection_event
  end

  it "records new event" do
    PlayerDisconnectedJob.perform player.id, world.id, Time.now - 120, Time.now

    world.events.should have(1).disconnection_event
  end
end