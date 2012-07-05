require 'test_helper'

class FacebookControllerTest < ActionController::TestCase

  test "get channel" do
    get :channel
    assert_response :success
  end

end
