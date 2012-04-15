require 'spec_helper'

describe WorldStartedJob do
  let(:world) { Fabricate :world }
  context '1 player online and 2 players offline' do
    let(:offline_users) { [Fabricate(:user), Fabricate(:user)] }

    before do
      # all players
      offline_users.each {|user| world.whitelisted_players.push user.minecraft_player }

      # connected players
      $redis = double('Redis')
      $redis.stub(:hgetall).with('players:playing') do
        { "#{world.creator.minecraft_player.id}" => "#{world.id}" }
      end
    end

    after do
      $redis = nil
    end

    it "should email offline players" do
      p "online: #{world.online_player_ids}"
      p "offline: #{world.offline_player_ids}"

      WorldStartedJob.perform world.id

      ActionMailer::Base.deliveries.map(&:to).flatten.
        should == offline_users.map(&:email)
    end
  end
end