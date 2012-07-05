require 'test_helper'

class PusherControllerTest < ActionController::TestCase

  test "get auth" do
    get :auth
    assert_response :success
  end

end
