require 'spec_helper'

describe PlayerDisconnectedJob do
  let(:world) { Fabricate :world }
  let(:player) { Fabricate :minecraft_player }

  it "records event" do
    PlayerDisconnectedJob.perform player.id, world.id, (Time.now - 120).to_s, Time.now.to_s

    world.events.should have(1).disconnection_event
  end
end