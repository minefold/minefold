require 'spec_helper'

describe PlayerOppedJob do
  let(:world) { Fabricate(:world) }
  let(:player) { Fabricate(:minecraft_player) }

  before { world.op_player! player }
  
  it "removes opped player" do
    PlayerDeoppedJob.perform world.id, world.creator.minecraft_player.username, player.username
    world.reload.opped_players.should_not include(player)
  end
end
