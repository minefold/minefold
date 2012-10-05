require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  
  test ".claim" do
    user = User.make!
    reward = Reward.make!(name: 'tests passed')
    
    mock(user).claim_reward!(reward)
    
    Reward.claim('tests passed', user)
  end
  
  test "#claim_reward!" do
    user = User.make!
    reward = Reward.make!
    
    mock(user).increment_credits!(reward.credits) { true }
    
    assert_difference ->{ user.reward_claims.size }, 1 do
      user.claim_reward!(reward)
    end
  end
  
  
end
