require 'spec_helper'

describe PlayerDisconnectedJob do
  let(:world) { Fabricate :world }
  let(:player) { Fabricate :user, current_world: world }

  it "records event" do
    PlayerDisconnectedJob.perform player.id, world.id, (Time.now - 120).to_s, Time.now.to_s

    world.events.should have(1).disconnection_event
  end
end