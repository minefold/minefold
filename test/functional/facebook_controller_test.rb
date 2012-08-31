require 'test_helper'

class FacebookControllerTest < ActionController::TestCase

  test "GET #channel" do
    get :channel
    assert_response :success
  end

end
