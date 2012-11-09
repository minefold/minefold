require 'test_helper'

class CreditsObserverTest < ActiveSupport::TestCase

  test "#before_create adds credits" do
    user = User.make!
    assert_equal User::FREE_CREDITS, user.credits
  end

end
