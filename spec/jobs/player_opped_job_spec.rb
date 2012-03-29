require 'spec_helper'

describe PlayerOppedJob do
  let(:world) { Fabricate(:world) }
  let(:player) { Fabricate(:minecraft_player) }

  it "adds player to ops" do
    PlayerOppedJob.perform world.id, world.creator.minecraft_player.username, player.username
    world.reload.opped_players.should include(player)
  end
end
