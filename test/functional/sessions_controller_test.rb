require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "get new" do
    get :new
    assert_response :success
  end

end
