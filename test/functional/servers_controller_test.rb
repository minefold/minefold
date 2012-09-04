require 'test_helper'

class ServersControllerTest < ActionController::TestCase

  test "GET #index unauthenticated" do
    get :index
    assert_unauthenticated_response
  end

  test "GET #index" do
    user = User.make!
    sign_in(user)

    get :index
    assert_response :success
  end

end
