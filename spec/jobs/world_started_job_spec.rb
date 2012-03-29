require 'spec_helper'

describe WorldStartedJob do
  let(:world) { Fabricate :world }
  context '1 player online and 2 players offline' do
    let(:users) { [Fabricate(:user), Fabricate(:user)] }
    
    before do
      # all players
      users.each {|user| world.whitelisted_players.push user.minecraft_player }
      
      # connected players
      world.stub(:online_player_ids) { [world.creator.minecraft_player.id.to_s] }
    end
    
    it "should email offline players" do
      WorldStartedJob.perform world.id

      ActionMailer::Base.deliveries.map(&:to).flatten.
        should == players.map(&:email)
    end
  end
end