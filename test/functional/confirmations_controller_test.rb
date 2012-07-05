require 'test_helper'

class ConfirmationsControllerTest < ActionController::TestCase

  setup_devise_mapping(:user)

  test "get show" do
    get :show, confirmation_token: 'abc'
    assert_response :redirect
  end

end
