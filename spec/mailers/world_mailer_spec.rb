require "spec_helper"

describe WorldMailer do
  describe "play_request" do
    let(:owner)     { create :user }
    let(:world)     { create :world, creator: owner }
    let(:requestor) { create :user }
    
    let(:mail)      { WorldMailer.play_request world.id, requestor.id }

    it "renders the headers" do
      mail.subject.should eq("#{requestor.username} would like to play in #{world.name}")
      mail.to.should eq([owner.email])
    end

    it "renders the body" do
      mail.body.encoded.should include(world.name)
      mail.body.encoded.should include(world.slug)
      mail.body.encoded.should include(requestor.username)
    end
  end

  describe "world_started" do
    let(:online_players)  { [create(:user), create(:user)] }
    let(:offline_players) { [create(:user), create(:user)] }
  
    let(:to_player) { offline_players.first }
  
    let(:world) do 
      w = create :world, creator:(online_players.first)
      w.stub(:player_ids) { (online_players + offline_players).map &:id }
      w.stub(:current_player_ids)     { (online_players).map &:id }
      w.events.create source: online_players.first, text: 'come mine with me!'
      w
    end
  
    let(:mail) { WorldMailer.world_started world.id, to_player.id }
    
    it "renders the headers" do
      mail.subject.should eq("Your friends are playing on Minefold in #{world.name}")
      mail.to.should eq([to_player.email])
    end

    it "renders the body" do
      mail.body.encoded.should include(world.name)
      mail.body.encoded.should include(world.slug)
      mail.body.encoded.should include(to_player.username)
    end
  end
  
  
end
