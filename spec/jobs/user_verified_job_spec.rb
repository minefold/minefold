require 'spec_helper'

describe UserVerifiedJob do
  let(:player) { Fabricate :minecraft_player }

  before {
    MinecraftPlayer.stub(:find_by_username).with(player.username) { player }
    player.stub(:online?) { true }
  }

  context 'bad code' do
    it 'tells player that code is bad' do
      player.should_receive(:tell).with('Sorry! That verification code is incorrect')

      UserVerifiedJob.perform(player.username, 'b4d c0d3')
    end
  end
  
  context 'good code' do
    let(:user) { Fabricate :user }
    
    it 'verifies player' do
      player.should_receive(:verify!).with(user)
      
      UserVerifiedJob.perform(player.username, user.verification_token)
    end
  end
end