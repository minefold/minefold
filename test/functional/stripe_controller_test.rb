require 'test_helper'

class StripeControllerTest < ActionController::TestCase

  test "get webhook" do
    get :webhook
    assert_response :success
  end

end
