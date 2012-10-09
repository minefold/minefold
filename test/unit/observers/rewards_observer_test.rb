require 'test_helper'

class RewardsObserverTest < ActiveSupport::TestCase
  
  test "#before_create adds credits" do
    Reward.make!(:facebook)
    
    user = User.make
    
    assert_empty user.rewards
    
    user.facebook_uid = '1234'
    user.save
    
    refute_empty user.rewards
  end
  
end
