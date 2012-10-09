require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  
  test ".claim" do
    user = User.make!
    reward = Reward.make!(name: 'tests passed')
    
    mock(user).increment_credits!(reward.credits)
    
    assert_difference ->{ reward.users.size }, 1 do
      Reward.claim('tests passed', user)
    end
    
    assert_difference ->{ reward.users.size }, 0 do
      Reward.claim('tests passed', user)
    end
  end
  
  test ".claim fails silently if no reward" do
    user = User.make!
    dont_allow(user).increment_credits!(anything)
    
    assert_nothing_raised ActiveRecord::RecordNotFound do
      Reward.claim('bogus reward', user)
    end
  end
  
end
