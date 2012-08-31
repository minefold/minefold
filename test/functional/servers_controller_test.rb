require 'test_helper'

class ServersControllerTest < ActionController::TestCase

  test "GET #index" do
    get :index
    assert_response :success
  end

end
