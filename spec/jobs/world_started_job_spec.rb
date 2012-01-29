require 'spec_helper'

describe WorldStartedJob do
  let(:world) { Fabricate :world }
  context '1 player online and 2 players offline' do
    let(:players) { [Fabricate(:user), Fabricate(:user)] }
    
    before do
      # all players
      players.each {|player| world.add_member player }
      
      # connected players
      world.stub(:player_ids) { [world.creator.id] }
    end
    
    it "should email offline players" do
      WorldStartedJob.perform world.id

      ActionMailer::Base.deliveries.map(&:to).flatten.
        should == players.map(&:email)
    end
  end
end