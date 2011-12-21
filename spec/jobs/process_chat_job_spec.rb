require 'spec_helper'

describe ProcessChatJob do
  let(:user) { create :user }
  let(:world) { create :world, creator: user }
  
  it "should create chat event" do
    ProcessChatJob.perform world.id, user.username, 'oh hai!'
    
    World.find(world.id).events.first.text.should == 'oh hai!'
  end
  # 
  # it "should set players referral state to played" do
  #   PlayerConnectedJob.perform user.username, Time.now
  #   
  #   User.find(user.id).referral_state.should == 'played'
  # end
end