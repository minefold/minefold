require 'spec_helper'

describe PlayerConnectedJob do
  let(:user) { create :user }
  
  it "should set players referral state to played" do
    PlayerConnectedJob.perform user.username, Time.now
    
    User.find(user.id).referral_state.should == 'played'
  end
end