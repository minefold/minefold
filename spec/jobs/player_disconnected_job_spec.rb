require 'spec_helper'

describe PlayerDisconnectedJob do
  let(:world) { Fabricate :world }
  let(:player) { Fabricate :user, current_world: world }

  it "records event" do
    PlayerDisconnectedJob.perform player.username, Time.now

    world.events.should have(1).disconnection_event
  end
end