require 'spec_helper'

describe WorldStartedJob do
  let(:world) { Fabricate :world }
  context '1 player online and 2 players offline' do
    let(:offline_users) { [Fabricate(:user), Fabricate(:user)] }

    before do
      # all players
      offline_users.each {|user| world.whitelisted_players.push user.minecraft_player }

      # connected players
      world.stub(:online_player_ids) { [world.creator.minecraft_player.id] }
    end

    it "should email offline players" do
      WorldStartedJob.perform world.id

      ActionMailer::Base.deliveries.map(&:to).flatten.
        should == offline_users.map(&:email)
    end
  end
end