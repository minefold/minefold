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
  
end
