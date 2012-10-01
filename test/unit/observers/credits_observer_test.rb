require 'test_helper'

class CreditsObserverTest < ActiveSupport::TestCase
  
  test "#before_create adds credits" do
    user = User.make!
    assert_equal 600, user.credits
  end
  
end
